//
//  UserDetailResponse.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct SettingUserDetailResponse: Codable {
    public let result: String
    public let data: SettingUserDetailData?
    public let message: String?
    public let errorCode: String?
}

public struct SettingUserDetailData: Codable {
    public let message: String?
    public let profilePictureUrl: String?
}
