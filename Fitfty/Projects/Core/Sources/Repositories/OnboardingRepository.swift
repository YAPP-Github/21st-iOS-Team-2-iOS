//
//  OnboardingRepository.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public protocol OnboardingRepository {
    
    func checkNickname(_ nickname: String) async throws -> Bool
}

public final class DefaultOnboardingRepository: OnboardingRepository {
    public init() {}
    
    public func checkNickname(_ nickname: String) async throws -> Bool {
        let response = try await FitftyAPI.request(target: .checkNickname(query: nickname), dataType: CheckNicknameResponse.self)
        return !response.data
    }
}
