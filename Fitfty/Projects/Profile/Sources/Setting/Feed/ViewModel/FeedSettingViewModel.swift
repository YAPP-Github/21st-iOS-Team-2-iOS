//
//  FeedSettingViewModel.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import Combine

enum FeedSettingSection {
    case genders
    case tags
    
    init?(index: Int) {
        switch index {
        case 0: self = .genders
        case 1: self = .tags
        default: return nil
        }
    }
    
    var title: String {
        switch self {
        case .genders: return "성별"
        case .tags: return "스타일 태그"
        }
    }
}

public final class FeedSettingViewModel: ViewModelType {
    
    public enum ViewModelState {
        
    }

    public var state: PassthroughSubject<ViewModelState, Never> = .init()

    public init() {}

}
