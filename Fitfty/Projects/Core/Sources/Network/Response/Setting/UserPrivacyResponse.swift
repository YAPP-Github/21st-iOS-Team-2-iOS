//
//  UserPrivacyResponse.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct UserPrivacyResponse: Codable {
    public let result: String
    public let data: UserData?
    public let message: String?
    public let errorCode: String?
}

public struct UserData: Codable {
    public let email: String
    public let userToken: String
    public let nickname: String
    public let phoneNumber: String?
    public let gender: String?
    public let birthday: String?
    public let role: String
}
