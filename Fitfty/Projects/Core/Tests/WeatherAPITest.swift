//
//  WeatherAPITest.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import XCTest
@testable import Core

final class WeatherAPITests: XCTestCase {
    var parameter: [String: Any] = [:]
    var apiKey: String = ProcessInfo.processInfo.environment["WEATHER_API_KEY"]?.removingPercentEncoding ?? "NoAPIKey"
    var todayDate: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        
        return dateFormatter.string(from: date)
    }
    
    override class func setUp() {}
    
    /// 로컬환경에서는 해당 테스트 Skip
    func test_EnviornmentVariable가_파싱됐는지() throws {
        try XCTSkipIf(apiKey == "local")
        XCTAssertFalse(apiKey == "NoAPIKey", "Fail To Parsing")
    }
    
    func test_FetchWeatherAPI_statusCode가_200인지() async throws {
        // Given
        parameter = [
            "numOfRows": "10",
            "pageNo": "1",
            "base_date": todayDate,
            "base_time": "0000",
            "nx": "55",
            "ny": "127"
        ]
        parameter.updateValue(apiKey, forKey: "serviceKey")
        
        do {
            // When
            let response = try await WeatherAPI.request(target: .fetchWeather(parameter: parameter))
            // Then
            XCTAssertEqual(response.statusCode, 200)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_FetchPastWeatherAPI_statusCode가_200인지() async throws {
        // Given
        parameter = [
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
        parameter.updateValue(apiKey, forKey: "serviceKey")

        do {
            // When
            let response = try await WeatherAPI.request(target: .fetchPastWeather(parameter: parameter))
            // Then
            XCTAssertEqual(response.statusCode, 200)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_FetchMiddleWeatherTemperature_statusCode가_200인지() async throws {
        // Given
        parameter = [
            "numOfRows": "10",
            "pageNo": "1",
            "regId": "11D20501",
            "tmFc": todayDate + "0600"
        ]
        parameter.updateValue(apiKey, forKey: "serviceKey")
        
        do {
            // When
            let response = try await WeatherAPI.request(target: .fetchMiddleWeatherTemperature(parameter: parameter))
            // Then
            XCTAssertEqual(response.statusCode, 200)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_FetchMiddleWeatherInfo_statusCode가_200인지() async throws {
        // Given
        parameter = [
            "numOfRows": "10",
            "pageNo": "1",
            "regId": "11D20501",
            "tmFc": todayDate + "0600"
        ]
        parameter.updateValue(apiKey, forKey: "serviceKey")
        
        do {
            // When
            let response = try await WeatherAPI.request(target: .fetchMiddleWeatherInfo(parameter: parameter))
            // Then
            XCTAssertEqual(response.statusCode, 200)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
