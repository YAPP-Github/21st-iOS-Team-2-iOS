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
    case styleTag(Tag)
    case cody(CodyResponse)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .weather(let shortTermForecast):
            hasher.combine(shortTermForecast)
            
        case .styleTag(let tag):
            hasher.combine(tag)
            
        case .cody(let cody):
            hasher.combine(cody)
        }

    }
    
}

extension MainCellModel: Equatable {
    
    static func == (lhs: MainCellModel, rhs: MainCellModel) -> Bool {
        switch (lhs, rhs) {
        case (.weather(let lhs), .weather(let rhs)):
            return lhs == rhs
            
        case (.cody(let lhs), .cody(let rhs)):
            return lhs == rhs
            
        case (.styleTag(let lhs), .styleTag(let rhs)):
            return lhs == rhs
        default: return false
        }
    }
}
