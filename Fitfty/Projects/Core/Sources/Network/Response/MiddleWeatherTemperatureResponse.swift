//
//  MiddleWeatherTemperatureResponse.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

// MARK: - MiddleWeatherTemperatureResponse
struct MiddleWeatherTemperatureResponse: Codable {
    let response: MiddleWeatherTemperatureResponseResult
}

// MARK: - Response
struct MiddleWeatherTemperatureResponseResult: Codable {
    let header: MiddleWeatherTemperatureResponseHeader
    let body: MiddleWeatherTemperatureResponseBody?
}

// MARK: - Body
struct MiddleWeatherTemperatureResponseBody: Codable {
    let dataType: String
    let items: MiddleWeatherTemperatureItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct MiddleWeatherTemperatureItems: Codable {
    let item: [MiddleWeatherTemperatureItem]
}

// MARK: - Item
struct MiddleWeatherTemperatureItem: Codable {
    let regID: String
    let taMin3: Int
    let taMin3Low: Int
    let taMin3High: Int
    let taMax3: Int
    let taMax3Low: Int
    let taMax3High: Int
    let taMin4: Int
    let taMin4Low: Int
    let taMin4High: Int
    let taMax4: Int
    let taMax4Low: Int
    let taMax4High: Int
    let taMin5: Int
    let taMin5Low: Int
    let taMin5High: Int
    let taMax5: Int
    let taMax5Low: Int
    let taMax5High: Int
    let taMin6: Int
    let taMin6Low: Int
    let taMin6High: Int
    let taMax6: Int
    let taMax6Low: Int
    let taMax6High: Int
    let taMin7: Int
    let taMin7Low: Int
    let taMin7High: Int
    let taMax7: Int
    let taMax7Low: Int
    let taMax7High: Int
    let taMin8: Int
    let taMin8Low: Int
    let taMin8High: Int
    let taMax8: Int
    let taMax8Low: Int
    let taMax8High: Int
    let taMin9: Int
    let taMin9Low: Int
    let taMin9High: Int
    let taMax9: Int
    let taMax9Low: Int
    let taMax9High: Int
    let taMin10: Int
    let taMin10Low: Int
    let taMin10High: Int
    let taMax10: Int
    let taMax10Low: Int
    let taMax10High: Int

    enum CodingKeys: String, CodingKey {
        case regID = "regId"
        case taMin3, taMin3Low, taMin3High, taMax3, taMax3Low, taMax3High, taMin4, taMin4Low, taMin4High, taMax4,
             taMax4Low, taMax4High, taMin5, taMin5Low, taMin5High, taMax5, taMax5Low, taMax5High, taMin6, taMin6Low,
             taMin6High, taMax6, taMax6Low, taMax6High, taMin7, taMin7Low, taMin7High, taMax7, taMax7Low, taMax7High,
             taMin8, taMin8Low, taMin8High, taMax8, taMax8Low, taMax8High, taMin9, taMin9Low, taMin9High, taMax9,
             taMax9Low, taMax9High, taMin10, taMin10Low, taMin10High, taMax10, taMax10Low, taMax10High
    }
}

// MARK: - Header
struct MiddleWeatherTemperatureResponseHeader: Codable {
    let resultCode: ResultCode
    let resultMsg: String
}

extension MiddleWeatherTemperatureItem {
    func temp(_ day: Int) -> (min: Int, max: Int)? {
        switch day {
        case 3: return (taMin3, taMax3)
        case 4: return (taMin4, taMax4)
        case 5: return (taMin5, taMax5)
        case 6: return (taMin6, taMax6)
        case 7: return (taMin7, taMax7)
        case 8: return (taMin8, taMax8)
        case 9: return (taMin9, taMax9)
        case 10: return (taMin10, taMax10)
        default: return nil
        }
    }
}
