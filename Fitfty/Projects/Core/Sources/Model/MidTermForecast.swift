//
//  MidTermForecast.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct MidTermForecast {
    
    public let meridiem: Meridiem
    public let date: Date
    public let forecast: Forecast
    public let precipitation: Int
    public let maxTemp: Int
    public let minTemp: Int
    
}

public extension MidTermForecast {
    
    var isToday: Bool {
        date.toString(.baseDate) == Date().toString(.baseDate)
    }
    
}

public enum Forecast: String, Codable {
    case sunny = "맑음"
    case lostOfCloudy = "구름많음"
    case cloudy = "흐림"
    case rain = "비"
    case rainOrSnow = "비 또는 눈"
    case snow = "눈"
    case scurry = "소나기"
}
