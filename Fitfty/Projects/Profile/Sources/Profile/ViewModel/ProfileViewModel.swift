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
    func viewWillAppearWithMenu(menuType: MenuType)
    func viewWillAppearWithoutMenu(nickname: String)
    func didTapMenu(_ menuType: MenuType)
    func didTapPostWithMenu(selectedIndex: Int, menuType: MenuType)
    func didTapPostWithoutMenu(selectedIndex: Int)
    
}

public final class ProfileViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var response: ProfileResponse?
    public init() { }
    
}

extension ProfileViewModel: ProfileViewModelInput {
    var input: ProfileViewModelInput { self }
    
    func viewWillAppearWithMenu(menuType: MenuType) {
        updateWithMenu(menuType: menuType)
    }
    
    func viewWillAppearWithoutMenu(nickname: String) {
        updateWithoutMenu(nickname: nickname)
    }
    
    func didTapMenu(_ menuType: MenuType) {
        switch menuType {
        case .myFitfty:
            updateWithMenu(menuType: menuType)
        case .bookmark:
            updateWithMenu(menuType: menuType)
        }
    }
    
    func didTapPostWithMenu(selectedIndex: Int, menuType: MenuType) {
        guard let myUserToken = response?.data?.userToken else {
            return
        }
        switch menuType {
        case .myFitfty:
            guard let otherUserToken = response?.data?.codiList[selectedIndex].userToken else {
                return
            }
            guard let boardToken = response?.data?.codiList[selectedIndex].boardToken else {
                return
            }
            if myUserToken == otherUserToken {
                currentState.send(.showPost(.myProfile, boardToken))
            } else {
                currentState.send(.showPost(.userProfile, boardToken))
            }
        case .bookmark:
            guard let otherUserToken = response?.data?.bookmarkList[selectedIndex].userToken else {
                return
            }
            guard let boardToken = response?.data?.bookmarkList[selectedIndex].boardToken else {
                return
            }
            if myUserToken == otherUserToken {
                currentState.send(.showPost(.myProfile, boardToken))
            } else {
                currentState.send(.showPost(.userProfile, boardToken))
            }
        }
    }
    
    func didTapPostWithoutMenu(selectedIndex: Int) {
        guard let myUserToken = response?.data?.userToken else {
            return
        }
        guard let otherUserToken = response?.data?.codiList[selectedIndex].userToken else {
            return
        }
        guard let boardToken = response?.data?.codiList[selectedIndex].boardToken else {
            return
        }
        if myUserToken == otherUserToken {
            currentState.send(.showPost(.myProfile, boardToken))
        } else {
            currentState.send(.showPost(.userProfile, boardToken))
        }
    }
    
}

extension ProfileViewModel: ViewModelType {
    
    public enum ViewModelState {
        case isLoading(Bool)
        case errorMessage(String)
        case update(ProfileResponse)
        case sections([ProfileSection])
        case showPost(ProfileType, String)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
}

extension ProfileViewModel {
    
    func updateWithoutMenu(nickname: String) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.currentState.send(.isLoading(true))
                
                let response = try await getOtherUserProfile(nickname: nickname)
                self.response = response
                if response.result == "SUCCESS" {
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
                } else {
                    currentState.send(.isLoading(false))
                    currentState.send(.errorMessage("프로필 조회에 알 수 없는 에러가 발생했습니다."))
                }
            } catch {
                Logger.debug(error: error, message: "프로필 조회를 실패")
                currentState.send(.isLoading(false))
                currentState.send(.errorMessage("프로필 조회에 알 수 없는 에러가 발생했습니다."))
            }
            
        }
    }
    
    func updateWithMenu(menuType: MenuType) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.currentState.send(.isLoading(true))
                
                let response = try await getMyProfile()
                self.response = response
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
    
    func getOtherUserProfile(nickname: String) async throws -> ProfileResponse {
        let response = try await FitftyAPI.request(
            target: .getOtherUserProfile(nickname: nickname),
            dataType: ProfileResponse.self
        )
        return response
    }
    
}
