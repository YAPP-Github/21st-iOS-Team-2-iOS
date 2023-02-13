//
//  UserPrivacy.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/13.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct UserPrivacy {
    public let email: String
    public let nickname: String?
    public let birtyday: String?
    public let gender: String?
    public let message: String?
    
    public init(email: String, nickname: String?, birtyday: String?, gender: String?, message: String?) {
        self.email = email
        self.nickname = nickname
        self.birtyday = birtyday
        self.gender = gender
        self.message = message
    }
}
