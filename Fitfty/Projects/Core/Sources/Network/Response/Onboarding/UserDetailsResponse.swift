//
//  UserDetailsResponse.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct UserDetailsResponse: Codable {
    let result: String
    let data: UserDetailsData?
    let message, errorCode: String?
}

// MARK: - DataClass
struct UserDetailsData: Codable {
    let email, userToken, nickname, gender: String
    let style: [String]
    let isOnBoardingComplete: Bool
}
