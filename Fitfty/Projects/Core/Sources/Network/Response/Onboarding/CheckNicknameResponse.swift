//
//  CheckNicknameResponse.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct CheckNicknameResponse: Codable {
    let result: String
    let data: Bool
    let message: String?
    let errorCode: String?
}
