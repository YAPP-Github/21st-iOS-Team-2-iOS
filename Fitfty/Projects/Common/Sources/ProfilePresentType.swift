//
//  PresentType.swift
//  Profile
//
//  Created by 임영선 on 2023/01/31.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum ProfilePresentType {
    
    case mainProfile
    case tabProfile
    
    public var headerHeight: CGFloat {
        switch self {
        case .mainProfile:
            return 196
        case .tabProfile:
            return 283
        }
    }
    
}
