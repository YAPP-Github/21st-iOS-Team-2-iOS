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
    case feed
    case pushNoti
    case logout
    case membershipWithdrawal
    case contact
    case birthDate
    case email
}

extension Setting {
    
    var title: String {
        switch self {
        case .profile: return "프로필 설정"
        case .myInfo: return "개인 정보 설정"
        case .feed: return "핏프티 피드 정보 설정"
        case .pushNoti: return "푸쉬 알림 설정"
        case .logout: return "로그아웃"
        case .membershipWithdrawal: return "회원 탈퇴"
        case .contact: return "휴대전화"
        case .birthDate: return "생년월일"
        case .email: return "이메일"
        }
    }
    
    var isNextPage: Bool {
        switch self {
        case .profile, .myInfo, .feed, .pushNoti: return true
        default: return false
        }
    }
    
    static func settings() -> [Setting] {
        return [.profile, .myInfo, .feed, .pushNoti]
    }
    
    static func etc() -> [Setting] {
        return [.logout, .membershipWithdrawal]
    }
    
    static func info() -> [Setting] {
        return [.contact, .birthDate, .email]
    }
    
}