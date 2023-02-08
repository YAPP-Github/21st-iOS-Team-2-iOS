//
//  Cody.swift
//  Core
//
//  Created by Ari on 2023/02/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

public struct Cody {
    public let imageURL: String
    public let description: String
    public let temp: Int
    public let locationFullName: String
    public let forecast: Forecast
    public let photoTakenTime: Date
    public let tags: FitftyTag
}

public struct FitftyTag {
    public let weather: WeatherTag
    public let style: StyleTag
    public let gender: Gender
}

public enum Gender: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
    
    var localized: String {
        switch self {
        case .male: return "남"
        case .female: return "여"
        }
    }
}
