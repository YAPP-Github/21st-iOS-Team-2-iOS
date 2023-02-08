//
//  MyFitftySection.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

public struct MyFitftySection {
    
    let sectionKind: MyFitftySectionKind
    var items: [MyFitftyCellModel]
    
}

enum MyFitftySectionKind {
    
    case content
    case weatherTag
    case styleTag
    
    init?(index: Int) {
        switch index {
        case 0: self = .content
        case 1: self = .weatherTag
        case 2: self = .styleTag
        default: return nil
        }
    }
}

enum MyFitftyCellModel: Hashable {
    
    case content(UUID)
    case styleTag(StyleTag, Bool)
    case weatherTag(WeatherTag, Bool)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .content(let uuid):
            hasher.combine(uuid)
            
        case .styleTag(let styleTag, let isSelected):
            hasher.combine(styleTag)
            hasher.combine(isSelected)
            
        case .weatherTag(let weatherTag, let isSelected):
            hasher.combine(weatherTag)
            hasher.combine(isSelected)
        }

    }
    
}
