//
//  ShortTermForecast.swift
//  Core
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

public struct ShortTermForecast {
    public let date: Date
    public let precipitation: String
    public let maxTemp: String
    public let minTemp: String
    public let skyState: SkyState
    public let precipitationPattern: PrecipitationPattern
}

public extension ShortTermForecast {
    
    init(_ items: [ShortTermForecastItem]) {
        self.date = items.first?.date ?? Date()
        self.precipitation = "\(items.filter { $0.category == .pop }.first?.fcstValue ?? "0")%"
        self.maxTemp = (items.filter { $0.category == .tmx }.first?.fcstValue ?? "0").decimalClean + "°"
        self.minTemp = (items.filter { $0.category == .tmn }.first?.fcstValue ?? "0").decimalClean + "°"
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
    
    public var icon: String {
        switch self {
        case .sunny: return ""
        case .lostOfCloudy: return ""
        case .cloudy: return ""
        }
    }
}

public enum PrecipitationPattern: String {
    case noon = "0"
    case rain = "1"
    case rainOrSnow = "2"
    case snow = "3"
    case scurry = "4"
    
    public var icon: String {
        switch self {
        case .noon: return ""
        case .rain: return ""
        case .rainOrSnow: return ""
        case .snow: return ""
        case .scurry: return ""
        }
    }
}
