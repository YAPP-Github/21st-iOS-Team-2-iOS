//
//  WelcomeViewModel.swift
//  MainFeed
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common

public final class WelcomeViewModel: ViewModelType {
    
    public enum ViewModelState {
        
    }

    public var state: PassthroughSubject<ViewModelState, Never> = .init()

    public init() {}

}

