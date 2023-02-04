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
    public let precipitation: Int
    public let temp: Int
    public let forecast: Forecast
}

public extension ShortTermForecast {
    
    init(_ items: [ShortTermForecastItem]) {
        self.date = items.first?.date ?? Date()
        self.precipitation = Int(items.filter { $0.category == .pop }.first?.fcstValue ?? "0") ?? 0
        self.temp = items.filter { $0.category == .tmp }.compactMap { Int($0.fcstValue) }.max() ?? 0
        let skyState = SkyState(
            rawValue: items.filter { $0.category == .sky }.first?.fcstValue ?? "1"
        ) ?? .sunny
        let precipitationPattern = PrecipitationPattern(
            rawValue: items.filter { $0.category == .pty }.first?.fcstValue ?? "0"
        ) ?? .noon
        let forecast = precipitationPattern == .noon ? skyState.localized : precipitationPattern.localized
        self.forecast = Forecast(rawValue: forecast) ?? .sunny
    }
    
    var isCurrent: Bool {
        date.toString(.mmddHH) == Date().toString(.mmddHH)
    }
    
    var isToday: Bool {
        date.toString(.baseDate) == Date().toString(.baseDate)
    }
}

extension ShortTermForecast: Equatable, Hashable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.date == rhs.date &&
        lhs.precipitation == rhs.precipitation &&
        lhs.temp == rhs.temp &&
        lhs.forecast == rhs.forecast
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(precipitation)
        hasher.combine(temp)
        hasher.combine(forecast)
    }
    
}

public enum SkyState: String {
    case sunny = "1"
    case lostOfCloudy = "3"
    case cloudy = "4"
    
    public var localized: String {
        switch self {
        case .sunny: return "맑음"
        case .lostOfCloudy: return "구름많음"
        case .cloudy: return "흐림"
        }
    }
}

public enum PrecipitationPattern: String {
    case noon = "0"
    case rain = "1"
    case rainOrSnow = "2"
    case snow = "3"
    case scurry = "4"
    
    public var localized: String {
        switch self {
        case .noon: return "없음"
        case .rain: return "비"
        case .rainOrSnow: return "비 또는 눈"
        case .snow: return "눈"
        case .scurry: return "소나기"
        }
    }
}
