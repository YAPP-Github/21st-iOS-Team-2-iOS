//
//  DailyWeather.swift
//  Core
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct DailyWeather {
    let date: Date
    let precipitation: String
    let maxTemp: String
    let minTemp: String
    let skyState: SkyState
    let precipitationPattern: PrecipitationPattern
}

public extension DailyWeather {
    
    init(_ items: [DailyWeatherItem]) {
        self.date = items.first?.date ?? Date()
        self.precipitation = "\(items.filter { $0.category == .pop }.first?.fcstValue ?? "0")%"
        self.maxTemp = (items.filter { $0.category == .tmx }.first?.fcstValue ?? "0")
            .replacingOccurrences(of: ".0", with: "") + "°"
        self.minTemp = (items.filter { $0.category == .tmn }.first?.fcstValue ?? "0")
            .replacingOccurrences(of: ".0", with: "") + "°"
        self.skyState = SkyState(
            rawValue: items.filter { $0.category == .sky }.first?.fcstValue ?? "1"
        ) ?? .sunny
        self.precipitationPattern = PrecipitationPattern(
            rawValue: items.filter { $0.category == .pty }.first?.fcstValue ?? "0"
        ) ?? .noon
    }
}

public enum SkyState: String {
    case sunny = "1"
    case lostOfCloudy = "3"
    case cloudy = "4"
}

public enum PrecipitationPattern: String {
    case noon = "0"
    case rain = "1"
    case rainOrSnow = "2"
    case snow = "3"
    case scurry = "4"
}
