//
//  PostReportRequest.swift
//  Core
//
//  Created by 임영선 on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct UserReportRequest: Codable {
    public let reportedUserToken: String
    public let type: [String]
    
    public init(reportedUserToken: String, type: [String]) {
        self.reportedUserToken = reportedUserToken
        self.type = type
    }
    
}
