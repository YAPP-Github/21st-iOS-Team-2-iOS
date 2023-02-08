//
//  WeatherNow.swift
//  Core
//
//  Created by Ari on 2023/01/29.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct WeatherNow: Codable {
    
    public let temp: Int
    public let forecast: Forecast
    public let date: Date
    
}
