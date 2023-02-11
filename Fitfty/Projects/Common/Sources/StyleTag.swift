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
            return "포멀"
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
}
