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
    
    var currentfullDate: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.fullDate.rawValue
        return dateFormatter.string(from: currentDate)
    }
    
    func toString(_ format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "KST")
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko-kr")
        return formatter.string(from: self)
    }
    
    func addDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? Date()
    }
    
}

public extension Date {
    func ISOStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: date).appending("Z")
    }
    
    func dateFromISOString(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: string)
    }
    
}

public enum DateFormat: String {
    case baseDate = "yyyyMMdd"
    case baseTime = "HHmm"
    case hour = "HH"
    case minute = "mm"
    case fcstDate = "yyyyMMddHHmm"
    case week = "E"
    case mmddDot = "M.d"
    case day = "dd"
    case log = "yyyy-MM-dd HH:mm:ss"
    case meridiemHour = "a h시"
    case yyyyMMddHyphen = "yyyy-MM-dd"
    case mmddHH = "MM/dd HH시"
    case yyMMddDot = "yy.MM.dd"
    case fullDate = "yyyy_MMdd_HHmm_ssSSSS"
}
