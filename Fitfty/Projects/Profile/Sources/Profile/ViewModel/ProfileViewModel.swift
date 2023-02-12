//
//  ProfileViewModel.swift
//  Profile
//
//  Created by 임영선 on 2023/02/01.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import Combine
import Core

protocol ProfileViewModelInput {
    
    var input: ProfileViewModelInput { get }
    func viewDidLoad(_ profileType: ProfileType, _ menuType: MenuType)
    func didTapMenu(_ menuType: MenuType)
    
}


public final class ProfileViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init() { }
    
}

extension ProfileViewModel: ProfileViewModelInput {
    var input: ProfileViewModelInput { self }
    
    func viewDidLoad(_ profileType: ProfileType, _ menuType: MenuType) {
        update(profileType: profileType, menuType: menuType)
    }
    
    func didTapMenu(_ menuType: MenuType) {
        switch menuType {
        case .myFitfty:
            update(profileType: .myProfile, menuType: .myFitfty)
        case .bookmark:
            update(profileType: .myProfile, menuType: .bookmark)
        }
    }
        
}

extension ProfileViewModel: ViewModelType {
    
    public enum ViewModelState {
        case isLoading(Bool)
        case errorMessage(String)
        case update(ProfileResponse)
        case sections([ProfileSection])
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }

}

extension ProfileViewModel {
    
    func update(profileType: ProfileType, menuType: MenuType) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.currentState.send(.isLoading(true))
                switch profileType {
                case .myProfile:
                    let response = try await getMyProfile()
                    if response.result == "SUCCESS" {
                        self.currentState.send(.update(response))
                        self.currentState.send(.isLoading(false))
                        
                        guard let data = response.data else {
                            return
                        }
                        var profileCellModels: [ProfileCellModel] = []
                        
                        switch menuType {
                        case .myFitfty:
                            for cody in data.codiList {
                                profileCellModels.append(ProfileCellModel.feed(cody.filePath, .myProfile, UUID()))
                            }
                            self.currentState.send(.sections([
                                ProfileSection(sectionKind: .feed, items: profileCellModels)
                            ]))
                        case .bookmark:
                            for cody in data.bookmarkList {
                                profileCellModels.append(ProfileCellModel.feed(cody.filePath, .myProfile, UUID()))
                            }
                            self.currentState.send(.sections([
                                ProfileSection(sectionKind: .feed, items: profileCellModels)
                            ]))
                        }
                    } else {
                        currentState.send(.isLoading(false))
                        currentState.send(.errorMessage("프로필 조회에 알 수 없는 에러가 발생했습니다."))
                    }
                    
                case .userProfile:
                    self.currentState.send(.isLoading(false))
                    
                }
            } catch {
                Logger.debug(error: error, message: "프로필 조회를 실패")
                currentState.send(.isLoading(false))
                currentState.send(.errorMessage("프로필 조회에 알 수 없는 에러가 발생했습니다."))
            }
            
        }
       
    }
    
    func getMyProfile() async throws -> ProfileResponse {
        let response = try await FitftyAPI.request(
            target: .getMyProfile,
            dataType: ProfileResponse.self
        )
        return response
    }
}
