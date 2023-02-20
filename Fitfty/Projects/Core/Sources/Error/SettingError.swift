//
//  SettingError.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/13.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum SettingError: Error {
    case noNickname
    case noBirthday
    case noAvailableBirthday
    case noAvailableNickname
    case overlappedNickname
    case failWithdrawAccount
    case noToken
    case others(String)
}

extension SettingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noNickname:
            return NSLocalizedString("닉네임을 입력해주세요", comment: "No Nickname")
        case .noBirthday:
            return NSLocalizedString("생년월일을 입력해주세요", comment: "No Birthday")
        case .noAvailableBirthday:
            return NSLocalizedString("올바른 생년월일을 기입해주세요", comment: "Wrong Birthday")
        case .noAvailableNickname:
            return NSLocalizedString("1자 이상의 영문과 숫자조합으로 이루어진 닉네임을 기입해주세요", comment: "Wrond Nickname")
        case .overlappedNickname:
            return NSLocalizedString("중복된 닉네임이에요", comment: "Overlapped Nickname")
        case .failWithdrawAccount:
            return NSLocalizedString("계정 탈퇴에 실패했어요. 잠시 후 다시 시도해주세요", comment: "Fail to Withdraw Account")
        case .noToken:
            return NSLocalizedString("토큰이 없습니다", comment: "No Token")
        case .others(let message):
            return NSLocalizedString(message, comment: "Others Message")
        }
    }
}
