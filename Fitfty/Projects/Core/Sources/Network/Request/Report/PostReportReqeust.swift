//
//  PostReportReqeust.swift
//  Core
//
//  Created by 임영선 on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct PostReportRequest: Codable {
    public let reportedBoardToken: String
    public let type: [String]
    
    public init(reportedBoardToken: String, type: [String]) {
        self.reportedBoardToken = reportedBoardToken
        self.type = type
    }
    
}
