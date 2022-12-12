//
//  WeatherAPITest.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import XCTest
@testable import Core

final class WeatherAPITests: XCTestCase {
    var todayDate: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        
        return dateFormatter.string(from: date)
    }
    
    func testFetchWeatherAPI_statusCode가_200인지() async throws {
        let parameter: [String: Any] = [
            "numOfRows": "10",
            "pageNo": "1",
            "base_date": todayDate,
            "base_time": "0000",
            "nx": "55",
            "ny": "127"
        ]
        
        do {
            let response = try await WeatherAPI.requestWeather(target: .fetchWeather(parameter: parameter))
            XCTAssertEqual(response.statusCode, 200)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testPastFetchWeatherAPI_statusCode가_200인지() async throws {
        let parameter: [String: Any] = [
            "numOfRows": "10",
            "pageNo": "1",
            "dataCd": "ASOS",
            "dateCd": "HR",
            "stnIds": "108",
            "startDt": "20221201",
            "startHh": "00",
            "endDt": "20221207",
            "endHh": "01"
        ]
        
        do {
            let response = try await WeatherAPI.requestWeather(target: .fetchPastWeather(parameter: parameter))
            XCTAssertEqual(response.statusCode, 200)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
