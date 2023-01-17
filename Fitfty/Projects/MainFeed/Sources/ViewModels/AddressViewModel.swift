//
//  AddressViewModel.swift
//  MainFeed
//
//  Created by Ari on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common

enum AddressViewSection {
    case address
    
    init?(index: Int) {
        switch index {
        case 0: self = .address
        default: return nil
        }
    }
}

public final class AddressViewModel: ViewModelType {
    
    public enum ViewModelState {
        
    }

    public var state: PassthroughSubject<ViewModelState, Never> = .init()

    public init() {}

}
