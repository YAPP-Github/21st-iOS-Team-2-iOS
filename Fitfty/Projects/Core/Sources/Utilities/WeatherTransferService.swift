//
//  WeatherTransferService.swift
//  Core
//
//  Created by Ari on 2023/01/23.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public protocol WeatherTransferService {
    
    /// 흩어져있는 단기예보 정보를 합쳐서 날짜순으로 반환합니다.
    func merge(by data: [ShortTermForecastItem]) -> [ShortTermForecast]
    
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
    
    /// 단기예보 데이터를 가지고, 3일간 중기예보를 직접 구해서 변환하여 반환합니다.
    ///
    /// 중기예보 API의 경우 3일차부터 10일차 까지의 예보를 내려줍니다.
    func convertThirdDayMidTermForecast(_ data: [ShortTermForecast]) -> [MidTermForecast]
    
    /// 중기기온, 중기육상예보 데이터를 완전한 중기예보로 합쳐서 변환하여 반환합니다.
    func merge(
        by tempResponse: MiddleWeatherTemperatureItem,
        to midTermForecastResponse: MidlandFcstItem
    ) -> [MidTermForecast]
    
    /// 파라미터로 받아온 위도, 경도를 활용하여 주소를 검색하여 반환합니다.
    func address(latitude: String, longitude: String) async throws -> String
    
    /// 받아온 주소를 통해서 지점 코드를 찾아 반환합니다. 만약 찾지 못한다면, 수도권기상청 지점코드를 대신 반환합니다.
    func branchCode(_ address: String) -> Int
    
}

public final class DefaultWeatherTransferService: WeatherTransferService {
    
    public init() {}
    
    public func merge(by data: [ShortTermForecastItem]) -> [ShortTermForecast] {
        let groupedItems: [Date: [ShortTermForecastItem]] = Dictionary(
            grouping: data,
            by: { ($0.fcstDate + $0.fcstTime).toDate(.fcstDate) ?? Date() }
        )
        return groupedItems
            .map { ShortTermForecast($0.value) }
            .sorted { $0.date < $1.date }
    }
    
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
    
    public func convertThirdDayMidTermForecast(_ data: [ShortTermForecast]) -> [MidTermForecast] {
        let today = Meridiem.allCases
            .map { convertMidTermForecast(data, meridiem: $0, date: Date()) }
        let nextDay = Meridiem.allCases
            .map { convertMidTermForecast(data, meridiem: $0, date: Date().addDays(1)) }
        let afterNextDay = Meridiem.allCases
            .map { convertMidTermForecast(data, meridiem: $0, date: Date().addDays(2)) }
        return today + nextDay + afterNextDay
    }
    
    public func merge(
        by tempResponse: MiddleWeatherTemperatureItem,
        to midTermForecastResponse: MidlandFcstItem
    ) -> [MidTermForecast] {
        var midTermForecastList: [MidTermForecast] = []
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

    public func address(latitude: String, longitude: String) async throws -> String {
        let searchAddress = AddressConversionRequest(x: Double(latitude) ?? 0, y: Double(longitude) ?? 0)
        return try await KakaoAPI.request(
            target: KakaoAPI.fetchAddressConversion(parameter: try searchAddress.asDictionary()),
            dataType: AddressConversionResponse.self
        ).documents
            .map { $0.address.addressName }.first ?? "서울"
    }
    
    public func branchCode(_ address: String) -> Int {
        let branchList = [
            "속초": 90, "북춘천": 93, "철원": 95, "동두천": 98, "파주": 99, "대관령": 100, "춘천": 101, "백령도": 102, "북강릉": 104,
            "강릉": 105, "동해": 106, "서울": 108, "인천": 112, "원주": 114, "울릉도": 115, "수원": 119, "영월": 121, "충주": 127,
            "서산": 129, "울진": 130, "청주": 131, "대전": 133, "추풍령": 135, "안동": 136, "상주": 137, "포항": 138, "군산": 140,
            "홍천": 212, "태백": 216, "정선군": 217, "제천": 221, "보은": 226, "천안": 232, "보령": 235, "부여": 236, "금산": 238,
            "세종": 239, "부안": 243, "임실": 244, "정읍": 245, "남원": 247, "장수": 248, "고창군": 251, "영광군": 252, "김해시": 253,
            "순창군": 254, "북창원": 255, "양산시": 257, "보성군": 258, "강진군": 259, "장흥": 260, "해남": 261, "고흥": 262, "의령군": 263,
            "대구": 143, "전주": 146, "울산": 152, "창원": 155, "광주": 156, "부산": 159, "통영": 162, "목포": 165, "여수": 168,
            "흑산도": 169, "완도": 170, "고창": 172, "순천": 174, "홍성": 177, "제주": 184, "고산": 185, "성산": 188, "서귀포": 189,
            "진주": 192, "강화": 201, "양평": 202, "이천": 203, "인제": 211, "함양군": 264, "광양시": 266, "진도군": 268, "봉화": 271,
            "영주": 272, "문경": 273, "청송군": 276, "영덕": 277, "의성": 278, "구미": 279, "영천": 281, "경주시": 283, "거창": 284,
            "합천": 285, "밀양": 288, "산청": 289, "거제": 294, "남해": 295
        ]
        return branchList
            .filter { address.contains($0.key) }
            .first?.value ?? 108
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
