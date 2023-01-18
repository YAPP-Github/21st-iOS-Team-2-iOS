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
}
