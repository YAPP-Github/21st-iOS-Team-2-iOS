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
    private var currentImage: CurrentValueSubject<Data?, Never> = .init(nil)

    public init(repository: SettingRepository) {
        self.repository = repository
    }
    
    func didTapSaveButton(message: String?) {
        Task {
            do {
                var url: String?
                if let imageData = currentImage.value {
                    let userToken = try await repository.getUserPrivacy().data?.userToken ?? UUID().uuidString
                    url = try await AmplifyManager.shared.uploadImage(data: imageData, fileName: "profile/\(userToken)").absoluteString
                }
                saveUserProfile(imageUrl: url, message: message)
            } catch {
                currentState.send(.showErrorAlert(error))
            }
        }
    }
    
    func didTapEditProfileImage(imageData: Data?) {
        currentImage.send(imageData)
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
