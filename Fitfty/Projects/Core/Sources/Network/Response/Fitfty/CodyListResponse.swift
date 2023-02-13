//
//  CodyListResponse.swift
//  Core
//
//  Created by Ari on 2023/02/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

// MARK: - Fitfty Main Cody List Response
public struct FitftyMainCodyListResponse: Codable {
    public let result: FitftyResult
    public let data: CodyListResponse?
    public let message: String?
    public let errorCode: String?
}

// MARK: - Fitfty Result
public enum FitftyResult: String, Codable {
    case success = "SUCCESS"
    case fail = "FAIL"
}

// MARK: - Cody List Response
public struct CodyListResponse: Codable {
    public let pictureDetailInfoList: [CodyResponse]
}

// MARK: - Cody Response
public struct CodyResponse: Codable {
    public let filePath: String
    public let boardToken: String
    public let userToken: String
    public let nickname: String
    public let profilePictureUrl: String?
    public let views: Int
    public let bookmarked: Bool
}

extension CodyResponse: Equatable, Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.filePath == rhs.filePath &&
        lhs.boardToken == rhs.boardToken &&
        lhs.userToken == rhs.userToken &&
        lhs.nickname == rhs.nickname &&
        lhs.profilePictureUrl == rhs.profilePictureUrl &&
        lhs.views == rhs.views &&
        lhs.bookmarked == rhs.bookmarked
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(boardToken)
        hasher.combine(userToken)
    }
}
