//
//  UserReportListResponse.swift
//  Core
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct UserReportListResponse: Codable {
    public let result: String
    public let data: [UserReportListData]?
    public let message, errorCode: String?
}

public struct UserReportListData: Codable {
    public let reportToken, reportUserToken, reportUserEmail, reportedUserToken: String
    public let reportedUserEmail: String
    public let reportedCount: Int
    public let type: [String]
    public let isConfirmed: Bool
}
