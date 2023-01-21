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
    
    func fetchShortTermForecast(longitude: String, latitude: String) async throws -> [ShortTermForecast]
    
}

public final class DefaultWeatherRepository: WeatherRepository {
    
    private var _shortTermForecast: [ShortTermForecast] = []
    
    public init() {}
    
    public func fetchShortTermForecast(longitude: String, latitude: String) async throws -> [ShortTermForecast] {
        let baseDate = baseDate(Date())
        let grid = LocationConverter.shared.grid(
            longitude: Double(longitude) ?? 0,
            latitude: Double(latitude) ?? 0
        )
        let request = try ShortTermForecastRequest(
            numOfRows: 1000,
            pageNo: 1,
            baseDate: baseDate.toString(.baseDate),
            baseTime: baseDate.toString(.baseTime),
            nx: grid.x,
            ny: grid.y
        ).asDictionary()
        do {
            let dailyWeatherDTO = try await WeatherAPI.request(
                target: WeatherAPI.fetchDailyWeather(parameter: request),
                dataType: ShortTermForecastResponse.self
            )
            if dailyWeatherDTO.response.header.resultCode != .normalService {
                throw dailyWeatherDTO.response.header.resultCode
            }
            let groupedItems = Dictionary(
                grouping: dailyWeatherDTO.response.body?.items.item ?? [],
                by: { ($0.fcstDate + $0.fcstTime).toDate(.fcstDate) ?? Date() }
            )
            let shortTermForecast = groupedItems
                .map { ShortTermForecast($0.value) }
                .sorted { $0.date < $1.date }
            _shortTermForecast = shortTermForecast
            return shortTermForecast
        } catch {
            throw error
        }
    }
}

private extension DefaultWeatherRepository {
    
    func baseDate(_ date: Date) -> Date {
        let currentHour = date.toString(.hour)
        let currentMinute = Int(date.toString(.minute)) ?? 0
        switch currentHour {
        case "03", "04", "05":
            let date = date.toString(.baseDate) + "0200"
            return date.toDate(.fcstDate) ?? Date()
            
        case "06", "07", "08":
            let date = date.toString(.baseDate) + "0500"
            return date.toDate(.fcstDate) ?? Date()
            
        case "09", "10", "11":
            let date = date.toString(.baseDate) + "0800"
            return date.toDate(.fcstDate) ?? Date()
            
        case "12", "13", "14":
            let date = date.toString(.baseDate) + "1100"
            return date.toDate(.fcstDate) ?? Date()
            
        case "15", "16", "17":
            let date = date.toString(.baseDate) + "1400"
            return date.toDate(.fcstDate) ?? Date()
            
        case "18", "19", "20":
            let date = date.toString(.baseDate) + "1700"
            return date.toDate(.fcstDate) ?? Date()
            
        case "21", "22", "23":
            let date = date.toString(.baseDate) + "2000"
            return date.toDate(.fcstDate) ?? Date()
            
        case "24", "00", "01", "02":
            let date = date.toString(.baseDate) + "2300"
            return date.toDate(.fcstDate) ?? Date()
            
        default: return (date.yesterday.toString(.baseDate) + "2300").toDate(.fcstDate) ?? Date()
        }
    }
    
}
