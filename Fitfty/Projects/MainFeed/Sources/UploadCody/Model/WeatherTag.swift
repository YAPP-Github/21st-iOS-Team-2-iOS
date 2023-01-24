//
//  WeatherTag.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//
import UIKit

enum WeatherTag {
    case coldWaveWeather
    case coldWeather
    case chillyWeather
    case warmWeather
    case hotWeather
    
    var weatherTagString: String {
        switch self {
        case .coldWaveWeather:
            return "❄️ 한파"
        case .coldWeather:
            return "🌨 추운날"
        case .chillyWeather:
            return "🍂 쌀쌀한 날"
        case .warmWeather:
            return "☀️ 따듯한 날"
        case .hotWeather:
            return "🔥 더운날"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .coldWaveWeather:
            return UIColor(red: 0.19, green: 0.485, blue: 0.929, alpha: 1)
        case .coldWeather:
            return UIColor(red: 0.147, green: 0.561, blue: 0.692, alpha: 1)
        case .chillyWeather:
            return UIColor(red: 0.483, green: 0.222, blue: 0.139, alpha: 1)
        case .warmWeather:
            return UIColor(red: 0.863, green: 0.517, blue: 0, alpha: 1)
        case .hotWeather:
            return UIColor(red: 0.825, green: 0.224, blue: 0.034, alpha: 1)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .coldWaveWeather:
            return UIColor(red: 0.783, green: 0.896, blue: 1, alpha: 1)
        case .coldWeather:
            return UIColor(red: 0.783, green: 0.974, blue: 1, alpha: 1)
        case .chillyWeather:
            return UIColor(red: 1, green: 0.862, blue: 0.762, alpha: 1)
        case .warmWeather:
            return UIColor(red: 1, green: 0.924, blue: 0.587, alpha: 1)
        case .hotWeather:
            return UIColor(red: 1, green: 0.842, blue: 0.88, alpha: 1)
        }
    }
}
