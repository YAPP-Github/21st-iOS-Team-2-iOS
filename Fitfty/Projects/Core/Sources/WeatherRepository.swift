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
    
    func fetchShortTermForecast(latitude: String, longitude: String) async throws -> [ShortTermForecast]
    
}

public final class DefaultWeatherRepository: WeatherRepository {
    
    private var _shortTermForecast: [ShortTermForecast] = []
    
    public init() {}
    
    public func fetchShortTermForecast(latitude: String, longitude: String) async throws -> [ShortTermForecast] {
        let baseDate = baseDate(Date())
        let request = try DailyWeatherRequest(
            numOfRows: 1000,
            pageNo: 1,
            baseDate: baseDate.toString(.baseDate),
            baseTime: baseDate.toString(.baseTime),
            nx: latitude,
            ny: longitude
        ).asDictionary()
        
        do {
            let dailyWeatherDTO = try await WeatherAPI.request(
                target: WeatherAPI.fetchDailyWeather(parameter: request),
                dataType: ShortTermForecastDTO.self
            )
            if dailyWeatherDTO.response.header.resultCode != .normalService {
                throw dailyWeatherDTO.response.header.resultCode
            }
            let filteredItems = dailyWeatherDTO.response.body?.items.item.filter {
                let date = ($0.fcstDate + $0.fcstTime).toDate(.fcstDate) ?? Date()
                return Date().toString(.hour) <= date.toString(.hour)
            } ?? []
            let groupedItems = Dictionary(
                grouping: filteredItems,
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
        case "02", "03", "04":
            let date = currentMinute <= 10 ? (date.yesterday.toString(.baseDate) + "2300") : date.toString(.baseDate) + "0200"
            return date.toDate(.fcstDate) ?? Date()
            
        case "05", "06", "07":
            let date = currentMinute <= 10 ? date.toString(.baseDate) + "0200" : date.toString(.baseDate) + "0500"
            return date.toDate(.fcstDate) ?? Date()
            
        case "08", "09", "10":
            let date = currentMinute <= 10 ? date.toString(.baseDate) + "0500" : date.toString(.baseDate) + "0800"
            return date.toDate(.fcstDate) ?? Date()
            
        case "11", "12", "13":
            let date = currentMinute <= 10 ? date.toString(.baseDate) + "0800" : date.toString(.baseDate) + "1100"
            return date.toDate(.fcstDate) ?? Date()
            
        case "14", "15", "16":
            let date = currentMinute <= 10 ? date.toString(.baseDate) + "1100" : date.toString(.baseDate) + "1400"
            return date.toDate(.fcstDate) ?? Date()
            
        case "17", "18", "19":
            let date = currentMinute <= 10 ? date.toString(.baseDate) + "1400" : date.toString(.baseDate) + "1700"
            return date.toDate(.fcstDate) ?? Date()
            
        case "20", "21", "22":
            let date = currentMinute <= 10 ? date.toString(.baseDate) + "1700" : date.toString(.baseDate) + "2000"
            return date.toDate(.fcstDate) ?? Date()
            
        case "23", "24":
            let date = currentMinute <= 10 ? date.toString(.baseDate) + "2000" : date.toString(.baseDate) + "2300"
            return date.toDate(.fcstDate) ?? Date()
            
        default: return (date.yesterday.toString(.baseDate) + "2300").toDate(.fcstDate) ?? Date()
        }
    }
    
}
