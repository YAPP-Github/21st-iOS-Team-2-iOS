//
//  WeatherRepository.swift
//  Core
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import CoreLocation

public protocol WeatherRepository {
    
    func fetchDailyWeather() async throws -> [DailyWeather]
    
}

public final class DefaultWeatherRepository: WeatherRepository {
    
    private let locationManager: CLLocationManager
    
    public init(locationManager: CLLocationManager = .init()) {
        self.locationManager = locationManager
    }
    
    public func fetchDailyWeather() async throws -> [DailyWeather] {
        let request = try DailyWeatherRequest(
            numOfRows: 1000,
            pageNo: 1,
            baseDate: Date().toString(.baseDate),
            baseTime: "1400",
            nx: Int(locationManager.location?.coordinate.latitude ?? 61).description,
            ny: Int(locationManager.location?.coordinate.longitude ?? 127).description
        ).asDictionary()
        guard let dailyWeatherDTO = try await WeatherAPI.request(
            target: WeatherAPI.fetchDailyWeather(parameter: request),
            dataType: DailyWeatherDTO.self
        ) else {
            throw WeatherRepositoryError.optionalBindingFailed
        }
        if dailyWeatherDTO.response.header.resultCode == .normalService {
            let filteredResponse: [DailyWeatherItem] = dailyWeatherDTO.response.body.items.item
                .filter {
                    let date = ($0.fcstDate + $0.fcstTime).toDate(.fcstDate) ?? Date()
                    return date > Date()
                }
            return Dictionary(
                grouping: filteredResponse,
                by: { ($0.fcstDate + $0.fcstTime).toDate(.fcstDate) ?? Date() }
            ).map { DailyWeather($0.value) }
                .sorted { $0.date < $1.date }
        } else {
            throw dailyWeatherDTO.response.header.resultCode
        }
            
    }
}

enum WeatherRepositoryError: LocalizedError {
    
    case optionalBindingFailed
    
    var errorDescription: String? {
        switch self {
        case .optionalBindingFailed: return "reqeust를 Dictionary"
        }
    }
    
}
