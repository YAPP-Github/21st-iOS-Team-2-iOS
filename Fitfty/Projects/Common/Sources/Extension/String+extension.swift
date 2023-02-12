//
//  String+extension.swift
//  Common
//
//  Created by 임영선 on 2022/12/30.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation

public extension String {
    
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let doubleValue = Double(self) {
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        return self
    }
    
    func toDate(_ format: DateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "KST")
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko-kr")
        return formatter.date(from: self)
    }
    
    var decimalClean: String {
        if let doubleValue = Double(self) {
            return Int(doubleValue).description
        } else {
            return self
        }
    }
    
    var stringToWeatherTag: WeatherTag? {
        switch self {
        case "HOT":
            return .hotWeather
        case "WARM":
            return .warmWeather
        case "CHILLY":
            return .chillyWeather
        case "COLD":
            return .coldWeather
        case "FREEZING":
            return .coldWaveWeather
        default: return nil
        }
    }
    
    var koreanWeatherTag: String {
        guard let temp = Int(self) else {
            return self
        }
        if temp >= 23 {
            return "더운 날"
        } else if temp >= 17 && temp < 23 {
            return "따뜻한 날"
        } else if temp >= 9 && temp < 17 {
            return "쌀쌀한 날"
        } else if temp >= 3 && temp < 9 {
            return "추운 날"
        } else {
            return "한파"
        }
    }
    
    var englishWeatherTag: String {
        guard let temp = Int(self) else {
            return self
        }
        if temp >= 23 {
            return "HOT"
        } else if temp >= 17 && temp < 23 {
            return "WARM"
        } else if temp >= 9 && temp < 17 {
            return "CHILLY"
        } else if temp >= 3 && temp < 9 {
            return "COLD"
        } else {
            return "FREEZING"
        }
    }
}
