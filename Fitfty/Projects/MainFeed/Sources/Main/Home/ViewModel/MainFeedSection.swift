//
//  MainFeedSection.swift
//  MainFeed
//
//  Created by Ari on 2023/02/04.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Core

public struct MainFeedSection: Hashable {
    
    let sectionKind: MainSectionKind
    var items: [MainCellModel]
    
}

enum MainSectionKind {
    case weather
    case style
    case cody
    
    init?(index: Int) {
        switch index {
        case 0: self = .weather
        case 1: self = .style
        case 2: self = .cody
        default: return nil
        }
    }
}

enum MainCellModel: Hashable {
    
    case weather(ShortTermForecast)
    case styleTag(UUID)
    case cody(UUID)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .weather(let shortTermForecast):
            hasher.combine(shortTermForecast)
            
        case .styleTag(let uuid):
            hasher.combine(uuid)
            
        case .cody(let uuid):
            hasher.combine(uuid)
        }

    }
    
}

extension MainCellModel: Equatable {
    
    static func == (lhs: MainCellModel, rhs: MainCellModel) -> Bool {
        switch (lhs, rhs) {
        case (.weather(let weatherLhs), .weather(let weatherRhs)):
            return weatherLhs == weatherRhs
            
        default: return false
        }
    }
}
