//
//  FitftyAPI.swift
//  Core
//
//  Created by Watcha-Ethan on 2022/12/18.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation
import Moya

public enum FitftyAPI {
    case signInKakao(parameters: [String: Any])
    case signInApple(parameters: [String: Any])
    case getMyProfile
    case postMyFitfty(parameters: [String: Any])
}

extension FitftyAPI: TargetType, AccessTokenAuthorizable {
    public var baseURL: URL {
        return URL(string: "http://52.79.144.104:8080/api/v1")!
    }
    
    public var authorizationType: AuthorizationType? {
        switch self {
        case .signInKakao,
             .signInApple:
            return .none
        default:
            return .bearer
        }
    }
    
    public var path: String {
        switch self {
        case .signInKakao:
            return "/auth/sign-in/kakao/"
        case .signInApple:
            return "/auth/sign-in/apple/"
        case .getMyProfile:
            return "/users/profile"
        case .postMyFitfty:
            return "/boards/new"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .signInKakao,
             .signInApple,
             .postMyFitfty:
            return .post
        case .getMyProfile:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .signInKakao(let parameters),
             .signInApple(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}

public extension FitftyAPI {
    static func request<T: Decodable>(target: FitftyAPI, dataType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            // TODO: 임시로 구현해둔 어드민 토큰 사용 코드. 로그인 기능 구현 완료 후 삭제할 코드입니다.
            let tokenClosure: (TargetType) -> String = { _ in
                return APIKey.adminToken
            }
            let authPlugin = AccessTokenPlugin(tokenClosure: tokenClosure)
            let provider = MoyaProvider<FitftyAPI>(plugins: [authPlugin])
            
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try JSONDecoder().decode(T.self, from: response.data)
                        continuation.resume(returning: data)
                        print("didFinishRequest URL [\(response.request?.url?.absoluteString ?? "")]")
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    static func request(target: FitftyAPI) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            // TODO: 임시로 구현해둔 어드민 토큰 사용 코드. 로그인 기능 구현 완료 후 삭제할 코드입니다.
            let tokenClosure: (TargetType) -> String = { _ in
                return APIKey.adminToken
            }
            let authPlugin = AccessTokenPlugin(tokenClosure: tokenClosure)
            let provider = MoyaProvider<FitftyAPI>(plugins: [authPlugin])
            
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
