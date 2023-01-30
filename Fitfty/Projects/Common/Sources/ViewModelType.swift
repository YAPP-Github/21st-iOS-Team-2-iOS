//
//  ViewModelType.swift
//  Common
//
//  Created by Watcha-Ethan on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation
import Combine

public protocol ViewModelType {
    associatedtype ViewModelState
    
    var state: AnyPublisher<ViewModelState, Never> { get }
}
