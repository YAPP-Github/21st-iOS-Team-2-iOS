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
    
    func fetchDailyWeather(latitude: String, longitude: String) async throws -> [DailyWeather]
    
}

public final class DefaultWeatherRepository: WeatherRepository {
    
    public init() {}
    
    public func fetchDailyWeather(latitude: String, longitude: String) async throws -> [DailyWeather] {
        let request = try DailyWeatherRequest(
            numOfRows: 1000,
            pageNo: 1,
            baseDate: Date().toString(.baseDate),
            baseTime: baseTime(Date()),
            nx: latitude,
            ny: longitude
        ).asDictionary()
        
        do {
            let dailyWeatherDTO = try await WeatherAPI.request(
                target: WeatherAPI.fetchDailyWeather(parameter: request),
                dataType: DailyWeatherDTO.self
            )
            if dailyWeatherDTO.response.header.resultCode != .normalService {
                throw dailyWeatherDTO.response.header.resultCode
            }
            let filteredItems = dailyWeatherDTO.response.body?.items.item.filter {
                let date = ($0.fcstDate + $0.fcstTime).toDate(.fcstDate) ?? Date()
                return Date() < date
            } ?? []
            let groupedItems = Dictionary(
                grouping: filteredItems,
                by: { ($0.fcstDate + $0.fcstTime).toDate(.fcstDate) ?? Date() }
            )
            let dailyWeather = groupedItems
                .map { DailyWeather($0.value) }
                .sorted { $0.date < $1.date }
            return dailyWeather
        } catch {
            throw error
        }
    }
}

private extension DefaultWeatherRepository {
    
    func baseTime(_ time: Date) -> String {
        let currentHour = time.toString(.hour)
        switch currentHour {
        case "02", "03", "04": return "0200"
        case "05", "06", "07": return "0500"
        case "08", "09", "10": return "0800"
        case "11", "12", "13": return "1100"
        case "14", "15", "16": return "1400"
        case "17", "18", "19": return "1700"
        case "20", "21", "22": return "2000"
        default: return "2300"
        }
    }
    
}
