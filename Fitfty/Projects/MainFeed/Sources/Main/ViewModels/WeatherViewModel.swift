//
//  WeatherViewModel.swift
//  MainFeed
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common

enum WeatherViewSection {
    case today
    case anotherDay
    
    init?(index: Int) {
        switch index {
        case 0: self = .today
        case 1: self = .anotherDay
        default: return nil
        }
    }
}

public final class WeatherViewModel: ViewModelType {
    
    public enum ViewModelState {
        
    }

    public var state: PassthroughSubject<ViewModelState, Never> = .init()

    public init() {}

}
