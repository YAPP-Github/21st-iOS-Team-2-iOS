//
//  CodyListRequest.swift
//  Core
//
//  Created by Ari on 2023/02/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct CodyListRequest: Codable {
    let weather: WeatherTag
}

public enum WeatherTag: String, Codable {
    case freezing = "FREEZING"
    case cold = "COLD"
    case chilly = "CHILLY"
    case warm = "WARM"
    case hot = "HOT"
}
