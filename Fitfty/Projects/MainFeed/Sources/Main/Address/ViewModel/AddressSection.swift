//
//  AddressSection.swift
//  MainFeed
//
//  Created by Ari on 2023/02/05.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Core

public struct AddressSection: Hashable {
    
    let sectionKind: AddressSectionKind
    var items: [Address]
    
}

enum AddressSectionKind {
    case address
    
    init?(index: Int) {
        switch index {
        case 0: self = .address
        default: return nil
        }
    }
}
