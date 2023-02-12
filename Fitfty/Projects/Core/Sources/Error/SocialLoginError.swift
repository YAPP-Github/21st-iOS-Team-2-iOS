//
//  SocialLoginError.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

enum SocialLoginError: Error {
    case noEmail
    case loginFail
    case expiredToken
    case noToken
    case others(String)
}

extension SocialLoginError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noEmail:
            return NSLocalizedString("이메일 제공에 동의해주셔야 서비스 이용이 가능해요", comment: "No Email")
        case .loginFail:
            return NSLocalizedString("로그인에 실패했습니다. 잠시 후 다시 시도해주세요", comment: "Login Fail")
        case .expiredToken:
            return NSLocalizedString("다시 로그인해주세요", comment: "Expired Token")
        case .noToken:
            return NSLocalizedString("토큰이 없습니다", comment: "No Token")
        case .others(let message):
            return NSLocalizedString(message, comment: "Others Message")
        }
    }
}
