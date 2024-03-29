//
//  UserPrivacyRequest.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/13.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct UserPrivacyRequest: Encodable {
    let nickname: String
    let birthday: String
    let gender: String
}
