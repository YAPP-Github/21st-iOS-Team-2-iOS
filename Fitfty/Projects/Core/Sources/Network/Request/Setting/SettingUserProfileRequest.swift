//
//  SettingUserProfileRequest.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct SettingUserProfileRequest: Encodable {
    let profilePictureUrl: String?
    let message: String?
}
