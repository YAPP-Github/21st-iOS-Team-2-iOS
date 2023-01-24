//
//  SearchAddressRequest.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct SearchAddressRequest: Codable {
    let query: String
    let page: Int
    let size: Int
}
