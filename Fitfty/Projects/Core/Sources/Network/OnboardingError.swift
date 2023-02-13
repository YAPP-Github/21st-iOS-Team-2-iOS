//
//  OnboardingError.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum OnboardingError: Error {
    case noUserData
    case others(String)
}

extension OnboardingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noUserData:
            return NSLocalizedString("유저 정보가 없어요. 로그인을 다시 진행해주세요", comment: "No User Data")
        case .others(let message):
            return NSLocalizedString(message, comment: "Others Message")
        }
    }
}
