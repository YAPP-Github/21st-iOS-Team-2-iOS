//
//  CodyListResponse.swift
//  Core
//
//  Created by Ari on 2023/02/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

// MARK: - Fitfty Main Cody List Response
struct FitftyMainCodyListResponse: Codable {
    let result: FitftyResult
    let data: CodyListResponse
    let message: String?
    let errorCode: String?
}

// MARK: - Fitfty Result
enum FitftyResult: String, Codable {
    case success = "SUCCESS"
    case fail = "FAIL"
}

// MARK: - Cody List Response
struct CodyListResponse: Codable {
    let pictureDetailInfoList: [CodyResponse]
}

// MARK: - Cody Response
struct CodyResponse: Codable {
    let filePath: String
    let boardToken, nickname: String
    let views: Int
    let bookmarked: Bool
}
