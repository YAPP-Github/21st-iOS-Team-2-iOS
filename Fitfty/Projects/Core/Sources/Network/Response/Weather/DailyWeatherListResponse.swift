//
//  DailyWeatherListResponse.swift
//  Core
//
//  Created by Ari on 2023/01/23.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

// MARK: - DailyWeatherListResponse
struct DailyWeatherListResponse: Codable {
    let response: DailyWeatherListResult
}

// MARK: - Response
struct DailyWeatherListResult: Codable {
    let header: DailyWeatherListHeader
    let body: DailyWeatherListBody?
}

// MARK: - Body
struct DailyWeatherListBody: Codable {
    let dataType: String
    let items: DailyWeatherListItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct DailyWeatherListItems: Codable {
    let item: [DailyWeatherItem]
}

// MARK: - Header
struct DailyWeatherListHeader: Codable {
    let resultCode: ResultCode
    let resultMsg: String
}

public struct DailyWeatherItem: Codable {
    let stnId: String
    let stnNm: String
    let tm: String
    let avgTa: String
    let minTa: String
    let minTaHrmt: String
    let maxTa: String
    let maxTaHrmt: String
    let mi10MaxRn: String
    let mi10MaxRnHrmt: String
    let hr1MaxRn: String
    let hr1MaxRnHrmt: String
    let sumRnDur: String
    let sumRn: String
    let maxInsWs: String
    let maxInsWsWd: String
    let maxInsWsHrmt: String
    let maxWs: String
    let maxWsWd: String
    let maxWsHrmt: String
    let avgWs: String
    let hr24SumRws: String
    let maxWd: String
    let avgTd: String
    let minRhm: String
    let minRhmHrmt: String
    let avgRhm: String
    let avgPv: String
    let avgPa: String
    let maxPs: String
    let maxPsHrmt: String
    let minPs: String
    let minPsHrmt: String
    let avgPs: String
    let ssDur: String
    let sumSsHr: String
    let hr1MaxIcsrHrmt: String
    let hr1MaxIcsr: String
    let sumGsr: String
    let ddMefs: String
    let ddMefsHrmt: String
    let ddMes: String
    let ddMesHrmt: String
    let sumDpthFhsc: String
    let avgTca: String
    let avgLmac: String
    let avgTs: String
    let minTg: String
    let avgCm5Te: String
    let avgCm10Te: String
    let avgCm20Te: String
    let avgCm30Te: String
    let avgM05Te: String
    let avgM10Te: String
    let avgM15Te: String
    let avgM30Te: String
    let avgM50Te: String
    let sumLrgEv: String
    let sumSmlEv: String
    let n99Rn: String
    let iscs: String
    let sumFogDur: String
}

public extension DailyWeatherItem {
    
    var forecast: Forecast {
        var iscs = self.iscs
        let removeList = ["{", "}", ".", " ", "km", "(미만)", "(이상)", "시정", "강도"]
        for str in removeList {
            iscs = iscs.replacingOccurrences(of: str, with: "")
        }
        iscs = iscs.filter { $0.isNumber == false }
        iscs = iscs.trimmingCharacters(in: ["-"])
        let weatherPhenomenonList = iscs.components(separatedBy: "-").map { ($0, 1)}
        return Forecast(
            rawValue: Dictionary(weatherPhenomenonList, uniquingKeysWith: +)
                .filter { Forecast(rawValue: $0.key) != nil }
                .max(by: { $0.value < $1.value })?.key ?? "맑음"
        ) ?? .sunny
        
    }
}
