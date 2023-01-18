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
            baseTime: "1400",
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
                return date > Date()
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
