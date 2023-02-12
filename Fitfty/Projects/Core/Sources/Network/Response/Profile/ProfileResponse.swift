//
//  ProfileResponse.swift
//  Core
//
//  Created by 임영선 on 2023/02/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct ProfileResponse: Codable {
    public let result: String
    public let data: ProfileData
    public let message, errorCode: String?
}

public struct ProfileData: Codable {
    public let userToken, nickname: String
    public let profilePictureUrl: String?
    public let message: String
    public let codiList, bookmarkList: [List]
}

public struct List: Codable {
    public let userToken, boardToken, filepath: String
}
