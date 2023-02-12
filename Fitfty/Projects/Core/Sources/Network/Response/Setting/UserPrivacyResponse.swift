//
//  UserPrivacyResponse.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct UserPrivacyResponse: Codable {
    let result: String
    let data: UserData?
    let message: String?
    let errorCode: String?
}

struct UserData: Codable {
    let email: String
    let userToken: String
    let nickname: String
    let phoneNumber: String?
    let gender: String?
    let birthday: String?
}
