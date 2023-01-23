//
//  WeatherTransferService.swift
//  Core
//
//  Created by Ari on 2023/01/23.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public protocol WeatherTransferService {
    
    /// 파라미터로 받아온 date를 통해 baseDate를 구합니다.
    ///
    /// 이 메소드는 기상청 API 단기예보조회 서비스를 참고하여 단기예보 발표시각을 구하게 됩니다.
    /// 예를 들어, date가 2023-01-21 14:05로 들어오는 경우, 2023-01-21 11:00을 반환하게 됩니다.
    func baseDate(_ date: Date) -> Date
    
    /// 과거 데이터 조회 시 baseDate를 구합니다.
    ///
    /// 이 메소드는 단기예보를 활용하여 1일부터 3일까지의 중기예보를 가져올 때 활용하는 메소드입니다.
    /// baseDate로 부터 시작하여 이후의 데이터만 내려오기 때문에, 무조건 02시 00분의 Date를 반환합니다.
    func pastBaseDate(_ date: Date) -> Date
    
    /// 파라미터로 받아온 date를 활용하여 중기육상예보조회 발표 시각(tmFc)을 구합니다.
    ///
    /// date에 따라 06:00시 또는 18:00시를 반환합니다.
    func announcementTime(_ date: Date) -> String
    
    /// 단기예보의 temp를 활용하여 최저온도, 최고온도를 구합니다.
    func minMaxTemp(_ data: [ShortTermForecast]) -> (min: Int, max: Int)
    
    /// 중기기온예보 구역코드(regld)를 구합니다.
    ///
    /// 자세한 구역코드 정보는 기상청 중기예보 조회 오픈 API 활용 가이드를 참고해주세요.
    func middleWeatherTempCode(_ address: String) -> String
    
    /// 중기육상예보 구역코드(regld)를 구합니다
    ///
    /// 자세한 구역코드 정보는 기상청 중기예보 조회 오픈 API 활용 가이드를 참고해주세요.
    func midTermLandForecastZone(_ address: String) -> String
    
    /// 단기예보 데이터로 제일 빈도수가 잦은 Forecast(비, 눈, 구름많음 등)를 구합니다.
    func forecast(_ data: [ShortTermForecast]) -> Forecast
    
    /// 단기예보 데이터를 가지고, 3일간 중기예보를 직접 구합니다.
    ///
    /// 중기예보 API의 경우 3일차부터 10일차 까지의 예보를 내려줍니다.
    func thirdDayMidTermForecast(_ data: [ShortTermForecast]) -> [MidTermForecast]
    
    /// 파라미터로 받아온 위도, 경도를 활용하여 주소를 검색하여 반환합니다.
    func address(latitude: String, longitude: String) async throws -> String
    
}

public final class DefaultWeatherTransferService: WeatherTransferService {
    
    public init() {}
    
    public func baseDate(_ date: Date) -> Date {
        let currentHour = date.toString(.hour)
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
            
        default: return (date.yesterday.toString(.baseDate) + "2300").toDate(.fcstDate) ?? Date()
        }
    }
    
    public func pastBaseDate(_ date: Date) -> Date {
        let currentHour = Int(date.toString(.hour)) ?? 0
        let dateString: String
        if currentHour >= 3 {
            dateString = date.toString(.baseDate) + "0200"
        } else {
            dateString = date.yesterday.toString(.baseDate) + "0200"
        }
        return dateString.toDate(.fcstDate) ?? Date()
    }
    
    public func announcementTime(_ date: Date) -> String {
        let currentTime = Int(date.toString(.hour)) ?? 0
        if currentTime <= 6 {
            return date.yesterday.toString(.baseDate) + "1800"
        } else if currentTime <= 18 {
            return date.toString(.baseDate) + "0600"
        } else {
            return date.toString(.baseDate) + "1800"
        }
    }
    
    public func minMaxTemp(_ data: [ShortTermForecast]) -> (min: Int, max: Int) {
        return data.reduce((
            min: data.first?.temp ?? 0,
            max: data.first?.temp ?? 0
        )) { partialResult, weather in
            var partialResult = partialResult
            partialResult.max = max(partialResult.max, weather.temp)
            partialResult.min = min(partialResult.min, weather.temp)
            return partialResult
        }
    }
    
    public func middleWeatherTempCode(_ address: String) -> String {
        return MiddleWeatherTemperatureZone.allCases
            .filter { zone in
                let keyword = zone.localized
                return address.contains(keyword)
            }.map { $0.code }.first ?? "11B10101"
    }
    
    public func midTermLandForecastZone(_ address: String) -> String {
        return MidTermLandForecastZone.allCases
            .filter { zone in
                let keywordList = zone.localized
                for keyword in keywordList where address.contains(keyword) {
                    return true
                }
                return false
            }.map { $0.code }.first ?? "11B00000"
    }
    
    public func forecast(_ data: [ShortTermForecast]) -> Forecast {
        return Dictionary(data.map { ($0.forecast, 1)}, uniquingKeysWith: +)
            .max { $0.value < $1.value }
            .flatMap { $0.key } ?? .sunny
    }
    
    public func thirdDayMidTermForecast(_ data: [ShortTermForecast]) -> [MidTermForecast] {
        let today = Meridiem.allCases
            .map { convertMidTermForecast(data, meridiem: $0, date: Date()) }
        let nextDay = Meridiem.allCases
            .map { convertMidTermForecast(data, meridiem: $0, date: Date().addDays(1)) }
        let afterNextDay = Meridiem.allCases
            .map { convertMidTermForecast(data, meridiem: $0, date: Date().addDays(2)) }
        return today + nextDay + afterNextDay
    }

    public func address(latitude: String, longitude: String) async throws -> String {
        let searchAddress = AddressConversionRequest(x: Double(latitude) ?? 0, y: Double(longitude) ?? 0)
        return try await KakaoAPI.request(
            target: KakaoAPI.fetchAddressConversion(parameter: try searchAddress.asDictionary()),
            dataType: AddressConversionResponse.self
        ).documents
            .map { $0.address.addressName }.first ?? "서울"
    }
    
    
}

private extension DefaultWeatherTransferService {
    
    func convertMidTermForecast(_ data: [ShortTermForecast], meridiem: Meridiem, date: Date) -> MidTermForecast {
        let data = data.filter { forecast in
            let currentHour = Int(forecast.date.toString(.hour)) ?? 0
            if meridiem == .am {
                return (0...11).contains(currentHour)
            } else {
                return (12...24).contains(currentHour)
            }
        }
        let forecast = forecast(data)
        let minMaxTempInfo = minMaxTemp(data)
        return MidTermForecast(
            meridiem: meridiem,
            date: date,
            forecast: forecast,
            precipitation: data.reduce(0) { max($0, $1.precipitation) },
            maxTemp: minMaxTempInfo.max,
            minTemp: minMaxTempInfo.min
        )
    }
    
}
