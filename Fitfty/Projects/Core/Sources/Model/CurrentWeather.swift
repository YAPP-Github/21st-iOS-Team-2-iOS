//
//  CurrentWeather.swift
//  Core
//
//  Created by Ari on 2023/01/24.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct CurrentWeather: Codable {
    
    public let temp: Int
    public let minTemp: Int
    public let maxTemp: Int
    public let forecast: Forecast
    public let date: Date
    
}
