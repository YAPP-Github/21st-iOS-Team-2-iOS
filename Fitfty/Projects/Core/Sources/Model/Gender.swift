//
//  Gender.swift
//  Core
//
//  Created by Ari on 2023/02/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum Gender: String, Codable, CaseIterable {
    case male = "MALE"
    case female = "FEMALE"
    
    public var localized: String {
        switch self {
        case .male: return "남"
        case .female: return "여"
        }
    }
}

public extension Gender {
    init?(_ localized: String) {
        switch localized {
        case "남":
            self = .male
            
        case "여":
            self = .female
            
        default:
            return nil
        }
    }
}
