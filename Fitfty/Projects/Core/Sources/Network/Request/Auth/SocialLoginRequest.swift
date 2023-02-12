//
//  SocialLoginRequest.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct AppleLoginRequest: Encodable {
    let userIdentifier: String
    let userName: String
    let userEmail: String
    let identityToken: String
}
