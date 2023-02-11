//
//  StyleTag.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//
import Foundation

public enum StyleTag: String, Codable, CaseIterable {
    case minimal = "MINIMAL"
    case modern = "MODERN"
    case casual = "CASUAL"
    case street = "STREET"
    case lovely = "LOVELY"
    case hip = "HIP"
    case luxury = "LUXURY"
    
    public var styleTagKoreanString: String {
        switch self {
        case .minimal: return "미니멀"
        case .modern: return "모던"
        case .casual: return "캐주얼"
        case .street: return "스트릿"
        case .lovely: return "러블리"
        case .hip: return "힙"
        case .luxury: return "럭셔리"
        }
    }
    
    public var styleTagEnglishString: String {
        switch self {
        case .minimal:
            return "MINIMAL"
        case .modern:
            return "MODERN"
        case .casual:
            return "CASUAL"
        case .street:
            return "STREET"
        case .lovely:
            return "LOVELY"
        case .hip:
            return "HIP"
        case .luxury:
            return "LUXURY"
        }
    }
    
    static public func tags() -> [StyleTag] {
        return [.minimal, .modern, .casual]
    }
    
    static public func otherTags() -> [StyleTag] {
        return [.hip, .street, .lovely, .luxury]
    }
}
