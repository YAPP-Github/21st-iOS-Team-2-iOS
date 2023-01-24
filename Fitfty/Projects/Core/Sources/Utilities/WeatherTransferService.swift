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
    func middleWeatherTempZoneCode(_ address: String) -> String
    
    /// 중기육상예보 구역코드(regld)를 구합니다
    ///
    /// 자세한 구역코드 정보는 기상청 중기예보 조회 오픈 API 활용 가이드를 참고해주세요.
    func midTermLandForecastZoneCode(_ address: String) -> String
    
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
    
    /// 받아온 주소를 통해서 기상청 지상 일자료 조회시 필요한 지점 코드를 찾아 반환합니다.
    /// 만약 찾지 못한다면, 수도권기상청 지점코드(108)를 대신 반환합니다.
    func dailyWeatherListBranchCode(_ address: String) -> Int
    
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
        let dateString: String = date.yesterday.toString(.baseDate) + "2300"
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
    
    public func middleWeatherTempZoneCode(_ address: String) -> String {
        let codeList = [
            "통영": "11H20401", "의정부": "11B20301", "태백": "11D20301", "증평": "11C10304", "고흥": "11F20403",
            "광양": "11F20402", "완도": "11F20301", "옥천": "11C10403", "경기도 광주": "11B20702", "경상도 고성군": "11H20404",
            "홍성": "11C20104", "울산": "11H20101", "울릉도": "1.10E+102", "여수": "11F20401", "양주": "11B20304",
            "신계": "11I10002", "하남": "11B20504", "대관령": "11D20201", "사리원": "11I10001", "예산": "11C20303",
            "추자도": "11G00800", "김포": "11B20102", "양양": "11D20403", "철원": "11D10101", "구미": "11H10602",
            "영주": "11H10401", "하동": "11H20704", "속초": "11D20401", "양덕": "11J20005", "영월": "11D10501",
            "용인": "11B20612", "동해": "11D20601", "익산": "11F10202", "의령": "11H20602", "보은": "11C10302",
            "대구": "11H10701", "웅기(선봉)": "11K10002", "장성": "11F20502", "이어도": "11G00601", "제주": "11G00201",
            "광주": "11F20501", "청송": "11H10503", "부천": "11B20204", "청도": "11H10704", "순창": "11F10403",
            "영암": "21F20802", "신안": "21F20803", "원주": "11D10401", "신의주": "11J10001", "서귀포": "11G00401",
            "청주": "11C10301", "성진(김책)": "11K10003", "거창": "11H20502", "담양": "11F20504", "부안": "21F10602",
            "안동": "11H10501", "여주": "11B20703", "성산": "11G00101", "보성": "11F20404", "희천": "11J10006",
            "순천시": "11F20405", "강계": "11J10005", "수원": "11B20601", "청진": "11K10001", "문경": "11H10301",
            "영양": "11H10403", "경산": "11H10703", "고성(장전)": "11L10002", "해남": "11F20302", "남양주": "11B20502",
            "오산": "11B20603", "함평": "21F20101", "곡성": "11F20602", "이천": "11B20701", "진도": "21F20201",
            "안산": "11B20203", "장수": "11F10301", "안성": "11B20611", "부여": "11C20501", "시흥": "11B20202",
            "화순": "11F20505", "임실": "11F10402", "연천": "11B20402", "보령": "11C20201", "풍산": "11K20005",
            "태안": "11C20102", "고창": "21F10601", "안양": "11B20602", "순천": "11F20603", "서산": "11C20101",
            "강원도 고성군": "11D20402", "고양": "11B20302", "해주": "11I20001", "진천": "11C10102", "세종": "11C20404",
            "인제": "11D10201", "강진": "11F20303", "파주": "11B20305", "영덕": "11H10102", "무안": "21F20804",
            "김천": "11H10601", "구성": "11J10003", "성남": "11B20605", "평택": "11B20606", "동두천": "11B20401",
            "가평": "11B20404", "의성": "11H10502", "아산": "11C20302", "진주": "11H20701", "금산": "11C20601",
            "남해": "11H20405", "평창": "11D10503", "무주": "11F10302", "함흥": "11K20001", "함안": "11H20603",
            "거제": "11H20403", "봉화": "11H10402", "청양": "11C20502", "안주": "11J20004", "삼척": "11D20602",
            "의왕": "11B20609", "인천": "11B20201", "창녕": "11H20604", "계룡": "11C20403", "백령면": "11A00101",
            "삭주(수풍)": "11J10002", "독도": "1.10E+103", "고령": "11H10604", "개성": "11I20002", "광명": "11B10103",
            "울진": "11H10101", "영천": "11H10702", "나주": "11F20503", "성주": "11H10605", "대전": "11C20401",
            "합천": "11H20503", "단양": "11C10202", "구리": "11B20501", "서천": "11C20202", "김해": "11H20304",
            "상주": "11H10302", "제천": "11C10201", "포항": "11H10201", "횡성": "11D10402", "화천": "11D10102",
            "양구": "11D10202", "자성(중강)": "11J10004", "충주": "11C10101", "양평": "11B20503", "목포": "21F20801",
            "논산": "11C20602", "군위": "11H10603", "부산": "11H20201", "정읍": "11F10203", "산청": "11H20703",
            "강릉": "11D20501", "남원": "11F10401", "장진": "11K20002", "추풍령": "11C10401", "창원": "11H20301",
            "영광": "21F20102", "성판악": "11G00302", "서울": "11B10101", "괴산": "11C10303", "장연(용연)": "11I20003",
            "장흥": "11F20304", "평양": "11J20001", "포천": "11B20403", "고산": "11G00501", "함양": "11H20501",
            "완주": "11F10204", "혜산": "11K20004", "경주": "11H10202", "진남포(남포)": "11J20002", "전주": "11F10201",
            "홍천": "11D10302", "영동": "11C10402", "음성": "11C10103", "천안": "11C20301", "과천": "11B10102",
            "진안": "11F10303", "원산": "11L10001", "평강": "11L10003", "구례": "11F20601", "흑산도": "11F20701",
            "김제": "21F10502", "밀양": "11H20601", "공주": "11C20402", "양산": "11H20102", "무산(삼지연)": "11K10004",
            "정선": "11D10502", "춘천": "11D10301", "강화군": "11B20101", "군포": "11B20610", "군산": "21F10501",
            "당진": "11C20103", "북청(신포)": "11K20003", "예천": "11H10303", "사천": "11H20402", "화성": "11B20604",
            "칠곡": "11H10705"
        ]
        return codeList
            .filter { address.contains($0.key) }
            .map { $0.value }.first ?? "11B10101"
    }
    
    public func midTermLandForecastZoneCode(_ address: String) -> String {
        let codeList = [
            ["대전", "세종", "충청남도"]: "11C20000", ["대구", "경상북도"]: "11H10000",
            ["충청북도"]: "11C10000", ["부산", "울산", "경상남도"]: "11H20000",
            ["강원도", "영동"]: "11D20000", ["강원도", "영서"]: "11D10000",
            ["서울", "인천", "경기도"]: "11B00000", ["제주"]: "11G00000",
            ["전라북도"]: "11F10000", ["광주", "전라남도"]: "11F20000"
        ]
        return codeList
            .filter {
                for keyword in $0.key where address.contains(keyword) {
                    return true
                }
                return false
            }.map { $0.value }.first ?? "11B00000"
    }
    
    public func forecast(_ data: [ShortTermForecast]) -> Forecast {
        return Dictionary(data.map { ($0.forecast, 1)}, uniquingKeysWith: +)
            .max { $0.value < $1.value }
            .flatMap { $0.key } ?? .sunny
    }
    
    public func convertThirdDayMidTermForecast(_ data: [ShortTermForecast]) -> [MidTermForecast] {
        let today = convertMidTermForecast(
            data.filter { $0.isToday },
            date: Date()
        )
        let nextDay = convertMidTermForecast(
            data.filter { $0.date.toString(.baseDate) == Date().addDays(1).toString(.baseDate)},
            date: Date().addDays(1)
        )
        let afterNextDay = convertMidTermForecast(
            data.filter { $0.date.toString(.baseDate) == Date().addDays(2).toString(.baseDate)},
            date: Date().addDays(2)
        )
        return [today, nextDay, afterNextDay]
    }
    
    public func merge(
        by tempResponse: MiddleWeatherTemperatureItem,
        to midTermForecastResponse: MidlandFcstItem
    ) -> [MidTermForecast] {
        var midTermForecastList: [MidTermForecast] = []
        for day in 3...9 {
            let temp = tempResponse.temp(day)
            let amOnshoreForecast = midTermForecastResponse.forecast(day, meridiem: .am)
            let pmOnshoreForecast = midTermForecastResponse.forecast(day, meridiem: .pm)
            midTermForecastList.append(MidTermForecast(
                date: Date().addDays(day),
                amforecast: Forecast(rawValue: amOnshoreForecast?.forecast ?? "") ?? .sunny,
                pmforecast: Forecast(rawValue: pmOnshoreForecast?.forecast ?? "") ?? .sunny,
                amPrecipitation: amOnshoreForecast?.precipitation ?? 0,
                pmPrecipitation: pmOnshoreForecast?.precipitation ?? 0,
                maxTemp: temp?.max ?? 0,
                minTemp: temp?.min ?? 0
            ))
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
    
    public func dailyWeatherListBranchCode(_ address: String) -> Int {
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
    
    func convertMidTermForecast(_ data: [ShortTermForecast], date: Date) -> MidTermForecast {
        let amData = data.filter { forecast in
            let currentHour = Int(forecast.date.toString(.hour)) ?? 0
            return (0...11).contains(currentHour)
        }
        let pmData = data.filter { forecast in
            let currentHour = Int(forecast.date.toString(.hour)) ?? 0
            return (12...24).contains(currentHour)
        }
        let amForecast = forecast(amData)
        let pmForecast = forecast(pmData)
        let minMaxTempInfo = minMaxTemp(data)
        return MidTermForecast(
            date: date,
            amforecast: amForecast,
            pmforecast: pmForecast,
            amPrecipitation: amData.reduce(0) { max($0, $1.precipitation) },
            pmPrecipitation: pmData.reduce(0) { max($0, $1.precipitation) },
            maxTemp: minMaxTempInfo.max,
            minTemp: minMaxTempInfo.min
        )
    }
    
}
