//
//  UserDetailsRequest.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct UserDetailsRequest: Codable {
    let nickname: String
    let gender: String
    let style: [String]
}
