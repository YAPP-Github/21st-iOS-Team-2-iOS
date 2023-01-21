//
//  KakaoAPI.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Moya

public enum KakaoAPI {
    case fetchSearchAddress(parameter: [String: Any])
    case fetchSearchRegionCode(parameter: [String: Any])
    case fetchAddressConversion(parameter: [String: Any])
}

extension KakaoAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://dapi.kakao.com")!
    }
    
    public var path: String {
        switch self {
        case .fetchSearchAddress: return "/v2/local/search/address.json"
        case .fetchSearchRegionCode: return "/v2/local/geo/coord2regioncode.json"
        case .fetchAddressConversion: return "/v2/local/geo/coord2address.json"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchSearchAddress(let parameter),
             .fetchSearchRegionCode(let parameter),
             .fetchAddressConversion(let parameter):
            
            let parameter = updateParameters(parameter)
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "KakaoAK \(APIKey.kakaoApiKey)"]
    }
}

public extension KakaoAPI {
    static func request<T: Decodable>(target: KakaoAPI, dataType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<KakaoAPI>()
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
    
    static func request(target: KakaoAPI) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<KakaoAPI>()
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

private extension KakaoAPI {
    func updateParameters(_ parameter: [String: Any]) -> [String: Any] {
        var parameter = parameter
        return parameter
    }
}
