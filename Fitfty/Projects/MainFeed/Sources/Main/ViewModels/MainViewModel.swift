//
//  MainViewModel.swift
//  MainFeed
//
//  Created by Ari on 2022/12/18.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common

enum MainViewSection {
    case weather
    case style
    case cody
    
    init?(index: Int) {
        switch index {
        case 0: self = .weather
        case 1: self = .style
        case 2: self = .cody
        default: return nil
        }
    }
}

final class MainViewModel: ViewModelType {
    
    public enum ViewModelState {
        
    }

    public var state: PassthroughSubject<ViewModelState, Never> = .init()

    public init() {}

}
