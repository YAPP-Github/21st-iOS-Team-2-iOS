//
//  PostReportListResponse.swift
//  Core
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct PostReportListResponse: Codable {
    let result: String
    let data: [PostReportListData]?
    let message, errorCode: String?
}

struct PostReportListData: Codable {
    let reportToken, reportUserToken, reportUserEmail, reportedBoardToken: String
    let reportedBoardFilePath: String
    let reportedCount: Int
    let type: [String]
    let isConfirmed: Bool
}
