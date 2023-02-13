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
    func getUserProfile() async throws -> SettingUserDetailResponse
    func updateUserProfile() async throws
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
        
        let response = try await FitftyAPI.request(
            target: .updateUserPrivacy(parameters: parameters),
            dataType: UserPrivacyResponse.self
        )
    }
    
    public func getUserProfile() async throws -> SettingUserDetailResponse {
        return try await FitftyAPI.request(target: .getMyProfile,
                                           dataType: SettingUserDetailResponse.self)
    }
    
    public func updateUserProfile() async throws {
        
    }
    
    public func withdrawAccount() async throws -> Bool {
        let resposne = try await FitftyAPI.request(target: .withdrawAccount,
                                                   dataType: WithdrawAccountResponse.self)
        return resposne.result == "SUCCESS" ? true : false
    }

    public func logout() {
        Keychain.deleteTokenData()
    }
}
