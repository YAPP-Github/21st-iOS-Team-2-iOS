//
//  WithdrawAccountResponse.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/13.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct WithdrawAccountResponse: Codable {
    let result: String
    let data: String?
    let message: String?
    let errorCode: String?
}
