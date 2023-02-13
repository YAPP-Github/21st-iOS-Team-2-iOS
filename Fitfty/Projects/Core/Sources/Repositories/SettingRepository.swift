//
//  SettingRepository.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/13.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public protocol SettingRepository {
    func getUserPrivacy() async throws -> UserPrivacyResponse
    func updateUserPrivacy(nickname: String, birthday: String, gender: String) async throws
    func getUserProfile() async throws -> SettingUserProfileResponse
    func updateUserProfile(profilePictureUrl: String?, message: String?) async throws
    func withdrawAccount() async throws -> Bool
    func logout()
}

public final class DefaultSettingRepository: SettingRepository {
    public init() {}
    
    public func getUserPrivacy() async throws -> UserPrivacyResponse {
        return try await FitftyAPI.request(target: .getUserPrivacy,
                                           dataType: UserPrivacyResponse.self)
    }
    
    public func updateUserPrivacy(nickname: String, birthday: String, gender: String) async throws {
        let parameters = try UserPrivacyRequest(nickname: nickname,
                                                birthday: birthday,
                                                gender: gender).asDictionary()
        
        _ = try await FitftyAPI.request(
            target: .updateUserPrivacy(parameters: parameters),
            dataType: UserPrivacyResponse.self
        )
    }
    
    public func getUserProfile() async throws -> SettingUserProfileResponse {
        return try await FitftyAPI.request(target: .getMyProfile,
                                           dataType: SettingUserProfileResponse.self)
    }
    
    public func updateUserProfile(profilePictureUrl: String?, message: String?) async throws {
        let parameters = try SettingUserProfileRequest(profilePictureUrl: profilePictureUrl ?? "",
                                                       message: message).asDictionary()
        let response = try await FitftyAPI.request(target: .updateMyProfile(parameters: parameters), dataType: SettingUserProfileResponse.self)
    }
    
    public func withdrawAccount() async throws -> Bool {
        let resposne = try await FitftyAPI.request(target: .withdrawAccount,
                                                   dataType: WithdrawAccountResponse.self)
        return resposne.result == "SUCCESS" ? true : false
    }

    public func logout() {
        SessionManager.shared.deleteUserSession()
    }
}
