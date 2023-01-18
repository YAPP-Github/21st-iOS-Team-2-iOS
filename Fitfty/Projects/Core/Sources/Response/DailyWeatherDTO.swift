//
//  DailyWeatherDTO.swift
//  Core
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

// MARK: - DailyWeatherDTO
public struct DailyWeatherDTO: Codable {
    let response: DailyWeatherResponse
}

// MARK: - Response
public struct DailyWeatherResponse: Codable {
    let header: DailyWeatherHeader
    let body: DailyWeatherBody?
}

// MARK: - Body
public struct DailyWeatherBody: Codable {
    let dataType: String
    let items: DailyWeatherItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
public struct DailyWeatherItems: Codable {
    let item: [DailyWeatherItem]
}

// MARK: - Item
public struct DailyWeatherItem: Codable {
    let baseDate, baseTime: String
    let category: WeatherInfoCategory
    /// 예측 일자
    let fcstDate: String
    /// 예측시간
    let fcstTime: String
    /// 예보 값
    let fcstValue: String
    let nx: Int
    let ny: Int
    
    var date: Date {
        return (fcstDate + fcstTime).toDate(.fcstDate) ?? Date()
    }
}

public enum WeatherInfoCategory: String, Codable {
    /// 1시간 강수량
    case pcp = "PCP"
    /// 강수확률
    case pop = "POP"
    /// 강수형태
    case pty = "PTY"
    /// 습도
    case reh = "REH"
    /// 하늘 상태
    case sky = "SKY"
    /// 1시간 신적설
    case sno = "SNO"
    /// 일 최저기온
    case tmn = "TMN"
    /// 1시간 기온
    case tmp = "TMP"
    /// 일 최고기온
    case tmx = "TMX"
    /// 풍속(동서성분)
    case uuu = "UUU"
    /// 풍향
    case vec = "VEC"
    /// 풍속(남북성분)
    case vvv = "VVV"
    /// 파고
    case wav = "WAV"
    /// 풍속
    case wsd = "WSD"
}

// MARK: - Header
public struct DailyWeatherHeader: Codable {
    let resultCode: ResultCode
    let resultMsg: String
}

public enum ResultCode: String, Codable, LocalizedError {
    case normalService = "00"
    case applicationError = "01"
    case dbError = "02"
    case nodataError = "03"
    case httpError = "04"
    case serviceTimeOut = "05"
    case invalidRequestParameterError = "10"
    case nomandatoryRequestParametersError = "11"
    case noOpenApiServiceError = "12"
    case serviceAccessDeniedError = "20"
    case temporarilyDisableTheServiceKeyError = "21"
    case limitedNumberOfServiceRequestsExceeds = "22"
    case serviceKeyIsNotRegisteredError = "30"
    case deadlineHasExpiredError = "31"
    case unregisteredIpError = "32"
    case unsignedCallError = "33"
    case unknownError = "99"
    
    public var errorDescription: String? {
        switch self {
        case .normalService: return "정상"
        case .applicationError: return "어플리케이션 에러"
        case .dbError: return "데이터베이스 에러"
        case .nodataError: return "데이터가 존재하지 않습니다."
        case .httpError: return "HTTP 에러"
        case .serviceTimeOut: return "서비스 연결 실패"
        case .invalidRequestParameterError: return "잘못된 파라미터로 요청하였습니다."
        case .nomandatoryRequestParametersError: return "필수 요청 파라미터가 존재하지 않습니다."
        case .noOpenApiServiceError: return "해당 오픈API 서비스가 없거나 폐기되었습니다."
        case .serviceAccessDeniedError: return "서비스에 접근하려고 했으나 거부되었습니다."
        case .temporarilyDisableTheServiceKeyError: return "일시적으로 사용할 수 없는 서비스 키 입니다."
        case .limitedNumberOfServiceRequestsExceeds: return "서비스 요청 제한 횟수 초과"
        case .serviceKeyIsNotRegisteredError: return "등록되지 않은 서비스 키 입니다."
        case .deadlineHasExpiredError: return "기한이 만료된 서비스 키 입니다."
        case .unregisteredIpError: return "등록되지 않은 IP 주소 입니다."
        case .unsignedCallError: return "서명되지 않은 호출입니다."
        case .unknownError: return "알 수 없는 에러가 발생했습니다."
        }
    }
}
