//
//  ProfileSettingViewModel.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine

import Common
import Core

public final class ProfileSettingViewModel: ViewModelType {
    public enum ViewModelState {
        case updateProfileMessage(_ message: String?)
        case updateProfileImage(_ url: String?)
        case dismiss
        case showErrorAlert(_ error: Error)
    }
    
    private let repository: SettingRepository
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)

    public init(repository: SettingRepository) {
        self.repository = repository
    }
    
    func didTapSaveButton(imageUrl: String?, message: String?) {
        saveUserProfile(imageUrl: imageUrl, message: message)
    }
    
    func getUserProfile() {
        Task {
            do {
                let response = try await repository.getUserProfile()
                
                currentState.send(.updateProfileMessage(response.data?.message))
                currentState.send(.updateProfileImage(response.data?.profilePictureUrl))
            } catch {
                currentState.send(.showErrorAlert(error))
            }
        }
    }
}

extension ProfileSettingViewModel {    
    private func saveUserProfile(imageUrl: String?, message: String?) {
        Task {
            do {
                try await repository.updateUserProfile(profilePictureUrl: imageUrl, message: message)
                
                currentState.send(.dismiss)
            } catch {
                currentState.send(.showErrorAlert(error))
            }
        }
    }
}
