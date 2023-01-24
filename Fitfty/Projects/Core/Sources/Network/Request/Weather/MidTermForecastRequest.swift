//
//  MidTermForecastRequest.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct MidTermForecastRequest: Codable {
    
    let numOfRows: Int
    let pageNo: Int
    let regId: String
    let tmFc: String
    
}
