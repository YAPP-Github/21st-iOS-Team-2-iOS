//
//  Setting.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

enum Setting {
    case profile
    case myInfo
    case termsOfUse
    case privacyRule
    case feed
    case pushNoti
    case logout
    case membershipWithdrawl
    case askHelp
    
    case contact
    case nickname
    case birthDate
    case email
    case gender
    case male
    case female
}

extension Setting {
    
    var title: String {
        switch self {
        case .profile: return "프로필 설정"
        case .myInfo: return "개인 정보 설정"
        case .termsOfUse: return "이용약관"
        case .privacyRule: return "개인정보처리방침"
        case .feed: return "핏프티 피드 정보 설정"
        case .pushNoti: return "푸쉬 알림 설정"
        case .logout: return "로그아웃"
        case .membershipWithdrawl: return "회원 탈퇴"
        case .askHelp: return "문의 하기"
        case .contact: return "휴대전화"
        case .nickname: return "닉네임"
        case .birthDate: return "생년월일"
        case .email: return "이메일"
        case .gender: return "성별"
        case .male: return "남성"
        case .female: return "여성"
        }
    }
    
    var isNextPage: Bool {
        switch self {
        case .profile, .myInfo, .termsOfUse, .privacyRule: return true
        default: return false
        }
    }
    
    static func settings() -> [Setting] {
        return [.profile, .myInfo, .termsOfUse, .privacyRule, .askHelp]
    }
    
    static func etc() -> [Setting] {
        return [.logout, .membershipWithdrawl]
    }
    
    static func info() -> [Setting] {
        return [.birthDate, .nickname, .email]
    }
    
    static func gender() -> [Setting] {
        return [.female, .male]
    }
    
}
