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
    func viewDidLoad(_ profileType: ProfileType)
}


public final class ProfileViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init() { }
    
}

extension ProfileViewModel: ProfileViewModelInput {
    var input: ProfileViewModelInput { self }
    
    func viewDidLoad(_ profileType: ProfileType) {
        update(profileType: profileType)
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
    
    func update(profileType: ProfileType) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.currentState.send(.isLoading(true))
                switch profileType {
                case .myProfile:
                    let response = try await getMyProfile()
                    guard response.result == "SUCCESS" else {
                        return
                    }
                    self.currentState.send(.update(response))
                    self.currentState.send(.isLoading(false))
                    
                    guard let data = response.data else {
                        return
                    }
                    
                    var profileCellModels: [ProfileCellModel] = []
                    for cody in data.codiList {
                        profileCellModels.append(ProfileCellModel.feed(cody.filePath, .myProfile, UUID()))
                    }
                    
                    self.currentState.send(.sections([
                        ProfileSection(sectionKind: .feed, items: profileCellModels)
                    ]))
                    
                case .userProfile:
                    self.currentState.send(.isLoading(false))
                }
            } catch {
                Logger.debug(error: error, message: "프로필 조회를 실패")
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
