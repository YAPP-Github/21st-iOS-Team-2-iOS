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
    
    func fetchMidTermForecast(longitude: String, latitude: String) async throws -> [MidTermForecast]
    
}

public final class DefaultWeatherRepository: WeatherRepository {
    
    private let transferService: WeatherTransferService
    private var _pastShortTermForecast: [ShortTermForecast] = []
    
    public init(transferService: WeatherTransferService = DefaultWeatherTransferService()) {
        self.transferService = transferService
        pastShortTermForecast(longitude: "127.016702905651", latitude: "37.5893588153919")
    }
    
    public func fetchShortTermForecast(longitude: String, latitude: String) async throws -> [ShortTermForecast] {
        return try await shortTermForecast(longitude: longitude, latitude: latitude, baseDate: transferService.baseDate(Date()))
    }
    
    public func fetchMidTermForecast(longitude: String, latitude: String) async throws -> [MidTermForecast] {
        let address: String = try await transferService.address(latitude: latitude, longitude: longitude)
        guard let tempResponse: MiddleWeatherTemperatureItem = try await middleWeatherTemperature(address),
              let midTermForecastResponse: MidlandFcstItem = try await midTermForecast(address) else {
            throw ResultCode.nodataError
        }
        var midTermForecastList: [MidTermForecast] = transferService.thirdDayMidTermForecast(_pastShortTermForecast)
        for day in 3...9 {
            let temp = tempResponse.temp(day)
            let forecastList = Meridiem.allCases
                .map { ($0, midTermForecastResponse.forecast(day, meridiem: $0)) }
            forecastList.forEach { forecast in
                let meridiem = forecast.0
                let forecast = forecast.1
                midTermForecastList.append(MidTermForecast(
                    meridiem: meridiem,
                    date: Date().addDays(day),
                    forecast: Forecast(rawValue: forecast?.forecast ?? "") ?? .sunny,
                    precipitation: forecast?.precipitation ?? 0,
                    maxTemp: temp?.max ?? 0,
                    minTemp: temp?.min ?? 0
                ))
            }
        }
        return midTermForecastList
    }
    
}

private extension DefaultWeatherRepository {
    
    func shortTermForecast(longitude: String, latitude: String, baseDate: Date) async throws -> [ShortTermForecast] {
        let grid = LocationConverter.shared.grid(
            longitude: Double(longitude) ?? 127,
            latitude: Double(latitude) ?? 61
        )
        let request = try ShortTermForecastRequest(
            numOfRows: 1000,
            pageNo: 1,
            baseDate: baseDate.toString(.baseDate),
            baseTime: baseDate.toString(.baseTime),
            nx: grid.x,
            ny: grid.y
        ).asDictionary()
        let response = try await WeatherAPI.request(
            target: WeatherAPI.fetchDailyWeather(parameter: request),
            dataType: ShortTermForecastResponse.self
        )
        if response.response.header.resultCode != .normalService {
            throw response.response.header.resultCode
        }
        let groupedItems: [Date: [ShortTermForecastItem]] = Dictionary(
            grouping: response.response.body?.items.item ?? [],
            by: { ($0.fcstDate + $0.fcstTime).toDate(.fcstDate) ?? Date() }
        )
        let shortTermForecast: [ShortTermForecast] = groupedItems
            .map { ShortTermForecast($0.value) }
            .sorted { $0.date < $1.date }
        return shortTermForecast
    }
    
    func middleWeatherTemperature(_ address: String) async throws -> MiddleWeatherTemperatureItem? {
        let middleWeatherTempCode: String = transferService.middleWeatherTempCode(address)
        let announcementTime: String = transferService.announcementTime(Date())
        let middleWeatherTempRequest: [String : Any] = try MidTermForecastRequest(
            numOfRows: 1000, pageNo: 1, regId: middleWeatherTempCode, tmFc: announcementTime
        ).asDictionary()
        let response = try await WeatherAPI.request(
            target: WeatherAPI.fetchMiddleWeatherTemperature(parameter: middleWeatherTempRequest),
            dataType: MiddleWeatherTemperatureResponse.self
        )
        if response.response.header.resultCode != .normalService {
            throw response.response.header.resultCode
        }
        return response.response.body?.items.item.first
    }
    
    func midTermForecast(_ address: String) async throws -> MidlandFcstItem? {
        let midTermForecastCode = transferService.midTermLandForecastZone(address)
        let announcementTime: String = transferService.announcementTime(Date())
        let midTermForecastRequest: [String : Any] = try MidTermForecastRequest(
            numOfRows: 1000, pageNo: 1, regId: midTermForecastCode, tmFc: announcementTime
        ).asDictionary()
        let response = try await WeatherAPI.request(
            target: WeatherAPI.fetchMidlandFcst(parameter: midTermForecastRequest),
            dataType: MidlandFcstResponse.self
        )
        if response.response.header.resultCode != .normalService {
            throw response.response.header.resultCode
        }
        return response.response.body?.items.item.first
    }
    
    func pastShortTermForecast(longitude: String, latitude: String) {
        Task {
            do {
                let pastShortTermForecastList: [ShortTermForecast] = try await shortTermForecast(
                    longitude: longitude, latitude: latitude, baseDate: transferService.pastBaseDate(Date())
                )
                _pastShortTermForecast = pastShortTermForecastList
            } catch {
                Logger.debug(error: error, message: "과거 날씨 데이터 요청 실패")
            }
        }
    }
    
}
