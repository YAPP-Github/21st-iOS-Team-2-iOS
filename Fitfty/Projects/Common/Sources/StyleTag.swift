//
//  StyleTag.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

public enum StyleTag {
    case minimal
    case modern
    case casual
    case street
    case lovely
    case hip
    case luxury
    
    public var styleTagKoreanString: String {
        switch self {
        case .minimal:
            return "미니멀"
        case .modern:
            return "모던"
        case .casual:
            return "캐주얼"
        case .street:
            return "스트릿"
        case .lovely:
            return "러블리"
        case .hip:
            return "힙"
        case .luxury:
            return "럭셔리"
        }
    }
    
    public var styleTagEnglishString: String {
        switch self {
        case .minimal:
            return "minimal"
        case .modern:
            return "modern"
        case .casual:
            return "casual"
        case .street:
            return "street"
        case .lovely:
            return "lovely"
        case .hip:
            return "hip"
        case .luxury:
            return "luxury"
        }
    }
    
    static public func tags() -> [StyleTag] {
        return [.minimal, .modern, .casual]
    }
    
    static public func otherTags() -> [StyleTag] {
        return [.hip, .street, .lovely, .luxury]
    }
}
