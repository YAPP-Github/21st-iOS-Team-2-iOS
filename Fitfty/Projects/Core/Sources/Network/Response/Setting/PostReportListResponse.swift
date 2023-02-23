//
//  PostReportListResponse.swift
//  Core
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct PostReportListResponse: Codable {
    public let result: String
    public let data: [PostReportListData]?
    public let message, errorCode: String?
}

public struct PostReportListData: Codable {
    public let reportToken, reportUserToken, reportUserEmail, reportedBoardToken: String
    public let reportedBoardFilePath: String
    public let reportedCount: Int
    public let type: [String]
    public let isConfirmed: Bool
}
