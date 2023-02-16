//
//  UserReportListResponse.swift
//  Core
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct UserReportListResponse: Codable {
    let result: String
    let data: [UserReportListData]?
    let message, errorCode: String?
}

struct UserReportListData: Codable {
    let reportToken, reportUserToken, reportUserEmail, reportedUserToken: String
    let reportedUserEmail: String
    let reportedCount: Int
    let type: [String]
    let isConfirmed: Bool
}
