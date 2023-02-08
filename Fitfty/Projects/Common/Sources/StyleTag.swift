//
//  StyleTag.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

public enum StyleTag {
    case formal
    case casual
    
    public var styleTagString: String {
        switch self {
        case .formal:
            return "포멀"
        case .casual:
            return "캐주얼"
        }
    }
}
