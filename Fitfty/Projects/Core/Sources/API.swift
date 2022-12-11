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
}

extension WeatherAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "http://apis.data.go.kr/1360000")!
    }
    
    public var path: String {
        switch self {
        case .fetchWeather: return "/VilageFcstInfoService_2.0/getUltraSrtNcst"
        case .fetchPastWeather: return "/AsosHourlyInfoService/getWthrDataList"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchWeather(let parameter), .fetchPastWeather(let parameter):
            let parameter = updateParameters(parameter)
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
}

public extension WeatherAPI {
    static func requestWeather<T: Decodable>(target: WeatherAPI, dataType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<WeatherAPI>()
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    print("didFinishRequest URL [\(response.request?.url?.absoluteString ?? "")]")
                    guard let data = try? JSONDecoder().decode(T.self, from: response.data) else {
                        return
                    }
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    static func requestWeather(target: WeatherAPI) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<WeatherAPI>()
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

// MARK: - FitftyAPI

public enum FitftyAPI {

}

private extension TargetType {
    func updateParameters(_ parameter: [String: Any]) -> [String: Any] {
        var parameter = parameter
        parameter.updateValue(APIKey.apiKey.removingPercentEncoding ?? "", forKey: "serviceKey")
        parameter.updateValue("json", forKey: "dataType")
        return parameter
    }
}
