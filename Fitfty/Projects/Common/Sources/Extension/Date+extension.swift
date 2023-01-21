//
//  Date+extension.swift
//  Common
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public extension Date {
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? Date()
    }
    
    func toString(_ format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "KST")
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko-kr")
        return formatter.string(from: self)
    }
    
}

public enum DateFormat: String {
    case baseDate = "yyyyMMdd"
    case baseTime = "HHmm"
    case hour = "HH"
    case minute = "mm"
    case fcstDate = "yyyyMMddHHmm"
    case week = "E"
    case monthDay = "MM.dd"
    case log = "yyyy-MM-dd HH:mm:ss"
}
