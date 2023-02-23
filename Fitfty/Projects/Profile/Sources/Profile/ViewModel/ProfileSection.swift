//
//  ProfileSection.swift
//  Profile
//
//  Created by 임영선 on 2023/02/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

public struct ProfileSection: Hashable {
    
    let sectionKind: ProfileSectionKind
    var items: [ProfileCellModel]
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sectionKind)
    }
        
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.sectionKind == rhs.sectionKind
    }
    
}

public enum ProfileSectionKind: Hashable {
    case feed
    
    init?(index: Int) {
        switch index {
        case 0: self = .feed
        default: return nil
        }
    }
}

enum ProfileCellModel: Hashable {
    
    case feed(String, ProfileType, UUID)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .feed(let filepath, let profileType, let uuid):
            hasher.combine(filepath)
            hasher.combine(profileType)
            hasher.combine(uuid)
        }
    }

}
