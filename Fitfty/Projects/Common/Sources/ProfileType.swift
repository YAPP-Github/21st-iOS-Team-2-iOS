//
//  ProfileType.swift
//  Profile
//
//  Created by 임영선 on 2023/01/30.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum ProfileType {
    
    case myProfile
    case userProfile
    
    public var headerHeight: CGFloat {
        switch self {
        case .userProfile:
            return 196
        case .myProfile:
            return 283
        }
    }
    
}
