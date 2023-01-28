//
//  FeedSetting.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

enum FeedSetting {
    case female
    case male
    case formal
    case casual
    case feminine
}

extension FeedSetting {
    
    var title: String {
        switch self {
        case .female: return "여성"
        case .male: return "남성"
        case .formal: return "포멀"
        case .casual: return "캐주얼"
        case .feminine: return "페미닌"
        }
    }
    static func genders() -> [FeedSetting] {
        return [.female, .male]
    }
    
    static func tags() -> [FeedSetting] {
        return [.formal, .casual, .feminine]
    }
    
}

