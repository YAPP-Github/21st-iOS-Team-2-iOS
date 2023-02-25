//
//  DailyWeather.swift
//  Core
//
//  Created by Ari on 2023/01/23.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct DailyWeather {
    
    public let date: Date
    public let averageTemp: String
    public let forecast: Forecast
    
}

public extension DailyWeather {
    
    init(_ item: DailyWeatherItem) {
        self.date = item.tm.toDate(.yyyyMMddHyphen) ?? Date()
        self.averageTemp = item.avgTa.decimalClean
        self.forecast = item.forecast
    }
}
