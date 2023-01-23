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
    
    func minMaxTemp() -> (min: Int, max: Int)

}

public final class DefaultWeatherRepository: WeatherRepository {
    
    private let transferService: WeatherTransferService
    private var _pastShortTermForecast: [ShortTermForecast] = []
    
    public init(transferService: WeatherTransferService = DefaultWeatherTransferService()) {
        self.transferService = transferService
        pastShortTermForecast(longitude: "127.016702905651", latitude: "37.5893588153919")
    }
    
    public func fetchShortTermForecast(longitude: String, latitude: String) async throws -> [ShortTermForecast] {
        return try await shortTermForecast(
            longitude: longitude,
            latitude: latitude,
            baseDate: transferService.baseDate(Date())
        )
    }
    
    public func fetchMidTermForecast(longitude: String, latitude: String) async throws -> [MidTermForecast] {
        let address: String = try await transferService.address(latitude: latitude, longitude: longitude)
        guard let tempResponse: MiddleWeatherTemperatureItem = try await middleWeatherTemperature(address),
              let midTermForecastResponse: MidlandFcstItem = try await midTermForecast(address) else {
            throw ResultCode.nodataError
        }
        var midTermForecastList: [MidTermForecast] = transferService
            .convertThirdDayMidTermForecast(_pastShortTermForecast)
        midTermForecastList.append(contentsOf: transferService.merge(by: tempResponse, to: midTermForecastResponse))
        return midTermForecastList
    }
    
    public func minMaxTemp() -> (min: Int, max: Int) {
        if _pastShortTermForecast.isEmpty {
            pastShortTermForecast(longitude: "127.016702905651", latitude: "37.5893588153919")
        }
        return transferService.minMaxTemp(_pastShortTermForecast)
    }
    
    public func fetchDailyWeather(for date: Date, longitude: String, latitude: String) async throws -> DailyWeather {
        let address: String = try await transferService.address(latitude: latitude, longitude: longitude)
        let request = try DailyWeatherListRequest(
            stnIds: transferService.dailyWeatherListBranchCode(address),
            startDt: date.toString(.baseDate),
            endDt: date.toString(.baseDate)
        ).asDictionary()
        let response = try await WeatherAPI.request(
            target: WeatherAPI.fetchDailyWeatherList(parameter: request),
            dataType: DailyWeatherListResponse.self
        )
        if response.response.header.resultCode != .normalService {
            throw response.response.header.resultCode
        }
        guard let item = response.response.body?.items.item.first else {
            throw ResultCode.nodataError
        }
        return DailyWeather(item)
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
            target: WeatherAPI.fetchShortTermForecast(parameter: request),
            dataType: ShortTermForecastResponse.self
        )
        if response.response.header.resultCode != .normalService {
            throw response.response.header.resultCode
        }
        return transferService.merge(by: response.response.body?.items.item ?? [])
    }
    
    func middleWeatherTemperature(_ address: String) async throws -> MiddleWeatherTemperatureItem? {
        let middleWeatherTempCode: String = transferService.middleWeatherTempZoneCode(address)
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
        let midTermForecastCode = transferService.midTermLandForecastZoneCode(address)
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
