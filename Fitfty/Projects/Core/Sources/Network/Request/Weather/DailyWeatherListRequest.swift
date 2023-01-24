//
//  DailyWeatherListRequest.swift
//  Core
//
//  Created by Ari on 2023/01/23.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct DailyWeatherListRequest: Codable {
    
    let numOfRows: Int
    let pageNo: Int
    let dataCd: String
    let dateCd: String
    let stnIds: Int
    let startDt: String
    let endDt: String
    
}

extension DailyWeatherListRequest {
    
    init(stnIds: Int, startDt: String, endDt: String) {
        self.numOfRows = 800
        self.pageNo = 1
        self.dataCd = "ASOS"
        self.dateCd = "DAY"
        self.stnIds = stnIds
        self.startDt = startDt
        self.endDt = endDt
    }
    
}
