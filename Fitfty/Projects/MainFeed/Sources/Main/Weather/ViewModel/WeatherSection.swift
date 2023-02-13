//
//  WeatherSection.swift
//  MainFeed
//
//  Created by Ari on 2023/02/06.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Core

public struct WeatherSection {
    
    let sectionKind: WeatherSectionKind
    var items: [WeatherCellModel]
    
}

enum WeatherSectionKind {
    case today
    case anotherDay
    
    init?(index: Int) {
        switch index {
        case 0: self = .today
        case 1: self = .anotherDay
        default: return nil
        }
    }
}

enum WeatherCellModel {
    
    case short(ShortTermForecast)
    case mid(MidTermForecast)
    
}

extension WeatherCellModel: Equatable, Hashable {
    
    static func == (lhs: WeatherCellModel, rhs: WeatherCellModel) -> Bool {
        switch (lhs, rhs) {
        case (.short(let lhs), .short(let rhs)):
            return lhs == rhs
            
        case (.mid(let lhs), .mid(let rhs)):
            return lhs == rhs
            
        default: return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .short(let shortTermForecast):
            hasher.combine(shortTermForecast)
            
        case .mid(let midTermForecast):
            hasher.combine(midTermForecast)
        }

    }
    
}
