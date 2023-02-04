//
//  ProfileViewModel.swift
//  Profile
//
//  Created by 임영선 on 2023/02/01.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

enum ProfileSection: CaseIterable {
    case feed
    
    init?(index: Int) {
        switch index {
        case 0: self = .feed
        default: return nil
        }
    }
}

public final class ProfileViewModel {
    
}
