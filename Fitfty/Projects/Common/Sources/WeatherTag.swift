//
//  WeatherTag.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//
import UIKit

public enum WeatherTag: String, Codable {
    case freezing = "FREEZING"
    case cold = "COLD"
    case chilly = "CHILLY"
    case warm = "WARM"
    case hot = "HOT"
    
    public var emojiWeatherTag: String {
        switch self {
        case .freezing:return "❄️ 한파"
        case .cold:return "🌨 추운 날"
        case .chilly:return "🍂 쌀쌀한 날"
        case .warm:return "☀️ 따뜻한 날"
        case .hot:return "🔥 더운 날"
        }
    }
    
    public var koreanWeatherTag: String {
        switch self {
        case .freezing: return "한파"
        case .cold: return "추운 날"
        case .chilly: return "쌀쌀한 날"
        case .warm: return "따뜻한 날"
        case .hot: return "더운 날"
        }
    }
    
    public var englishWeatherTag: String {
        switch self {
        case .freezing: return "FREEZING"
        case .cold: return "COLD"
        case .chilly: return "CHILLY"
        case .warm: return "WARM"
        case .hot: return "HOT"
        }
    }
    
    public var textColor: UIColor {
        switch self {
        case .freezing:
            return UIColor(red: 0.19, green: 0.485, blue: 0.929, alpha: 1)
        case .cold:
            return UIColor(red: 0.147, green: 0.561, blue: 0.692, alpha: 1)
        case .chilly:
            return UIColor(red: 0.483, green: 0.222, blue: 0.139, alpha: 1)
        case .warm:
            return UIColor(red: 0.863, green: 0.517, blue: 0, alpha: 1)
        case .hot:
            return UIColor(red: 0.825, green: 0.224, blue: 0.034, alpha: 1)
        }
    }
    
    public var backgroundColor: UIColor {
        switch self {
        case .freezing:
            return UIColor(red: 0.783, green: 0.896, blue: 1, alpha: 1)
        case .cold:
            return UIColor(red: 0.783, green: 0.974, blue: 1, alpha: 1)
        case .chilly:
            return UIColor(red: 1, green: 0.862, blue: 0.762, alpha: 1)
        case .warm:
            return UIColor(red: 1, green: 0.924, blue: 0.587, alpha: 1)
        case .hot:
            return UIColor(red: 1, green: 0.842, blue: 0.88, alpha: 1)
        }
    }
    
}
extension WeatherTag {
    public init(temp: Int) {
        if temp <= 3 {
            self = .freezing
        } else if temp >= 3, temp <= 9 {
            self = .cold
        } else if temp >= 9, temp <= 17 {
            self = .chilly
        } else if temp >= 17, temp <= 23 {
            self = .warm
        } else {
            self = .hot
        }
    }
}
