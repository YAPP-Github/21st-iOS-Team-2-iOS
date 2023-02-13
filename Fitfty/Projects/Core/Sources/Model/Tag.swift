//
//  Tag.swift
//  Core
//
//  Created by Ari on 2023/02/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

public struct Tag {
    
    public let title: String
    public let isSelected: Bool
    
    public init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    public var isGender: Bool {
        return Gender.allCases.map { $0.localized }.contains(title)
    }
    
    public var isStyle: Bool {
        return StyleTag.allCases.map { $0.styleTagKoreanString }.contains(title)
    }
    
}

extension Tag: Hashable, Equatable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title && lhs.isSelected == rhs.isSelected
    }
    
}
