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
    private var profilePictureUrl: CurrentValueSubject<String?, Never> = .init(nil)
    
    public init(repository: SettingRepository) {
        self.repository = repository
    }
    
    func didTapSaveButton(message: String?) {
        guard checkAvailableMessage(message) else {
            return
        }
        
        Task {
            do {
                var url: String?
                if let imageData = currentImage.value,
                   let filename = filenameFromFilepath(profilePictureUrl.value) {
                    let userToken = try await repository.getUserPrivacy().data?.userToken ?? UUID().uuidString
                    url = try await AmplifyManager.shared.uploadImage(data: imageData, fileName: "profile/\(userToken)_\(Date().currentfullDate)").absoluteString
                    try await AmplifyManager.shared.delete(fileName: filename)
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
                profilePictureUrl.send(response.data?.profilePictureUrl)
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
        let message = message?.isEmpty == true ? nil : message
        Task {
            do {
                try await repository.updateUserProfile(profilePictureUrl: imageUrl, message: message)
                
                currentState.send(.dismiss)
            } catch {
                currentState.send(.showErrorAlert(error))
            }
        }
    }
    
    private func checkAvailableMessage(_ message: String?) -> Bool {
        guard message?.count ?? 0 <= 30 else {
            currentState.send(.showErrorAlert(SettingError.tooManyMessage))
            return false
        }
        return true
    }
    
    private func filenameFromFilepath(_ filepath: String?) -> String? {
        guard let filepath = filepath else {
            return nil
        }
        if filepath.contains("profile") {
            let splitProfile = filepath.components(separatedBy: "profile")
            return "profile" + splitProfile[1]
        } else {
            return nil
        }
    }
}
