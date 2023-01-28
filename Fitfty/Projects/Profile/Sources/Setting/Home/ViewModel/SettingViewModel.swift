//
//  SettingViewModel.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import Combine

enum SettingViewSection {
    case setting
    case etc
    
    init?(index: Int) {
        switch index {
        case 0: self = .setting
        case 1: self = .etc
        default: return nil
        }
    }
}

public final class SettingViewModel: ViewModelType {
    
    public enum ViewModelState {
        
    }

    public var state: PassthroughSubject<ViewModelState, Never> = .init()

    public init() {}

}
