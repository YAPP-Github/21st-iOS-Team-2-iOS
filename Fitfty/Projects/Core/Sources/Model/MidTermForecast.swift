//
//  MidTermForecast.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public struct MidTermForecast {
    
    public let date: Date
    public let amforecast: Forecast
    public let pmforecast: Forecast
    public let amPrecipitation: Int
    public let pmPrecipitation: Int
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
    case cloudAndSun = "구름많음"
    case cloudy = "흐림"
    case rain = "비"
    case rainOrSnow = "비 또는 눈"
    case snow = "눈"
    case scurry = "소나기"
    
    public var icon: UIImage {
        switch self {
        case .sunny: return CommonAsset.Images.sunny.image
        case .cloudAndSun: return CommonAsset.Images.cloudAndSun.image
        case .cloudy: return CommonAsset.Images.cloudy.image
        case .rain: return CommonAsset.Images.rain.image
        case .rainOrSnow: return CommonAsset.Images.rainOrSnow.image
        case .snow: return CommonAsset.Images.snow.image
        case .scurry: return CommonAsset.Images.scurry.image
        }
    }
}

extension MidTermForecast: Equatable, Hashable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.date == rhs.date &&
        lhs.amforecast == rhs.amforecast &&
        lhs.pmforecast == rhs.pmforecast &&
        lhs.amPrecipitation == rhs.amPrecipitation &&
        lhs.pmPrecipitation == rhs.pmPrecipitation &&
        lhs.maxTemp == rhs.maxTemp &&
        lhs.minTemp == rhs.minTemp
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(amforecast)
        hasher.combine(pmforecast)
        hasher.combine(amPrecipitation)
        hasher.combine(pmPrecipitation)
        hasher.combine(maxTemp)
        hasher.combine(minTemp)
    }
    
}
