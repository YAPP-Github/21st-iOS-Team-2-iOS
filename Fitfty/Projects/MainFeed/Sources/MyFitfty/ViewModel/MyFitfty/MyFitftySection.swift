//
//  MyFitftySection.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct MyFitftySection {
    
    let sectionKind: MyFitftySectionKind
    var items: [UUID]
    
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
