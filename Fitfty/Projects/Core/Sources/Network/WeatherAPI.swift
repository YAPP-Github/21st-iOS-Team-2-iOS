//
//  API.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import Foundation
import Moya

// MARK: - WeatherAPI

public enum WeatherAPI {
    case fetchWeather(parameter: [String: Any])
    case fetchPastWeather(parameter: [String: Any])
    case fetchMiddleWeatherTemperature(parameter: [String: Any])
    case fetchMiddleWeatherInfo(parameter: [String: Any])
    case fetchShortTermForecast(parameter: [String: Any])
    case fetchMidlandFcst(parameter: [String: Any])
    case fetchDailyWeatherList(parameter: [String: Any])
}

extension WeatherAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "http://apis.data.go.kr/1360000")!
    }
    
    public var path: String {
        switch self {
        case .fetchWeather: return "/VilageFcstInfoService_2.0/getUltraSrtFcst"
        case .fetchPastWeather: return "/AsosHourlyInfoService/getWthrDataList"
        case .fetchMiddleWeatherTemperature: return "/MidFcstInfoService/getMidTa"
        case .fetchMiddleWeatherInfo: return "/MidFcstInfoService/getMidLandFcst"
        case .fetchShortTermForecast: return "/VilageFcstInfoService_2.0/getVilageFcst"
        case .fetchMidlandFcst: return "/MidFcstInfoService/getMidLandFcst"
        case .fetchDailyWeatherList: return "/AsosDalyInfoService/getWthrDataList"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchWeather(let parameter),
             .fetchPastWeather(let parameter),
             .fetchMiddleWeatherTemperature(let parameter),
             .fetchMiddleWeatherInfo(let parameter),
             .fetchShortTermForecast(let parameter),
             .fetchDailyWeatherList(let parameter),
             .fetchMidlandFcst(let parameter):
            
            let parameter = updateParameters(parameter)
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
}

public extension WeatherAPI {
    static func request<T: Decodable>(target: WeatherAPI, dataType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<WeatherAPI>()
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    print("didFinishRequest URL [\(response.request?.url?.absoluteString ?? "")]")
                    do {
                        let data = try JSONDecoder().decode(T.self, from: response.data)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    static func request(target: WeatherAPI) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<WeatherAPI>(plugins: [MoyaCacheablePlugin()])
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    print("didFinishRequest URL [\(response.request?.url?.absoluteString ?? "")]")
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

private extension TargetType {
    func updateParameters(_ parameter: [String: Any]) -> [String: Any] {
        var parameter = parameter
        parameter.updateValue(APIKey.weatherApiKey.removingPercentEncoding ?? "", forKey: "serviceKey")
        parameter.updateValue("json", forKey: "dataType")
        return parameter
    }
}

extension WeatherAPI: MoyaCacheable {
    var cachePolicy: MoyaCacheablePolicy {
        switch self {
        default: return .returnCacheDataElseLoad
        }
    }
}
