//
//  MyFitftyPresentType.swift
//  Common
//
//  Created by 임영선 on 2023/02/02.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum MyFitftyType {
    case uploadMyFitfty
    case modifyMyFitfty
    
    public var navigationBarTitle: String {
        switch self {
        case .modifyMyFitfty:
            return "내 핏프티 수정"
        case .uploadMyFitfty:
            return "새 핏프티 등록"
        }
    }
    
    public var buttonTitle: String {
        switch self {
        case .modifyMyFitfty:
            return "수정"
        case .uploadMyFitfty:
            return "등록"
        }
    }
}
