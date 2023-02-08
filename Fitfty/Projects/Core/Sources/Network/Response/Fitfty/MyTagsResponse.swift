//
//  MyTagsResponse.swift
//  Core
//
//  Created by Ari on 2023/02/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

// MARK: - Welcome
public struct FitftyMyTagsResponse: Codable {
    public let result: String
    public let data: MyTagsResponse
    public let message: String?
    public let errorCode: String?
}

// MARK: - DataClass
public struct MyTagsResponse: Codable {
    public let email: String
    public let userToken: String
    public let nickname: String
    public let gender: Gender
    public let style: [StyleTag]
    public let isOnBoardingComplete: Bool
}
