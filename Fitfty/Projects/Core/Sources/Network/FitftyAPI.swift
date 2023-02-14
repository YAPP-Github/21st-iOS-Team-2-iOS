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
    case getUserPrivacy
    case getMyProfile
    case getPost(boardToken: String)
    case checkNickname(query: String)
    case setUserDetails(parameters: [String: Any])
    case postMyFitfty(parameters: [String: Any])
    case getOtherUserProfile(nickname: String)
    case deletePost(boardToken: String)
    case putPost(parameters: [String: Any], boardToken: String)
    case codyList(parameters: [String: Any])
    case filteredCodyList(parameters: [String: Any])
    case mySettings
    case addBookmark(boardToken: String)
    case deleteBookmark(boardToken: String)
    case reportUser(parameters: UserReportRequest)
    case reportPost(parameters: PostReportRequest)
}

extension FitftyAPI: TargetType, AccessTokenAuthorizable {
    public var baseURL: URL {
        return URL(string: "http://52.79.144.104:8080/api/v1")!
    }
    
    public var authorizationType: AuthorizationType? {
        switch self {
        case .signInKakao,
             .signInApple,
             .getPost,
             .getOtherUserProfile:
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
        case .getUserPrivacy:
            return "/users/privacy"
        case .getMyProfile:
            return "/users/profile"
        case .getPost(let boardToken):
            return "/boards/\(boardToken)"
        case .checkNickname(let query):
            return "/users/nickname/\(query)"
        case .setUserDetails:
            return "/users/details"
        case .postMyFitfty:
            return "/boards/new"
        case .getOtherUserProfile(let nickname):
            return "/users/profile/\(nickname)"
        case .deletePost(let boardToken):
            return "/boards/\(boardToken)"
        case .putPost(_, let boardToken):
            return "/boards/\(boardToken)"
        case .codyList:
            return "/styles"
        case .filteredCodyList:
            return "/styles/filter"
        case .mySettings:
            return "/users/details"
        case .addBookmark(let boardToken),
             .deleteBookmark(let boardToken):
            return "/boards/bookmark/\(boardToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        case .reportUser:
            return "/reports/user/new"
        case .reportPost:
            return "/reports/board/new"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .signInKakao,
             .signInApple,
             .postMyFitfty,
             .addBookmark,
             .reportUser,
             .reportPost:
            return .post
            
        case .getMyProfile,
             .getUserPrivacy,
             .checkNickname,
             .getPost,
             .getOtherUserProfile:
            return .get
        case .deletePost:
            return .delete

        case .codyList,
             .mySettings,
             .filteredCodyList:
            return .get
            
        case .setUserDetails,
             .putPost:
            return .put
            
        case .deleteBookmark:
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .signInKakao(let parameters),
             .signInApple(let parameters),
             .setUserDetails(let parameters),
             .postMyFitfty(let parameters),
             .codyList(let parameters),
             .putPost(let parameters, _):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .reportPost(let parameters):
            return .requestJSONEncodable(parameters)
            
        case .reportUser(let parameters):
            return .requestJSONEncodable(parameters)
            
        case .filteredCodyList(let parameter):
            let parameters = updateParameters(parameter)
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets)
            )
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
            let provider = MoyaProvider<FitftyAPI>(plugins: [getAuthPlugin()])
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
            let provider = MoyaProvider<FitftyAPI>(plugins: [getAuthPlugin()])
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
    
    private static func getAuthPlugin() -> AccessTokenPlugin {
        let tokenClosure: (TargetType) -> String = { _ in
            guard let identifier = UserDefaults.standard.read(key: .userIdentifier) as? String,
                  let account = UserDefaults.standard.read(key: .userAccount) as? String,
                  let token = Keychain.loadData(serviceIdentifier: identifier, forKey: account) else {
                Logger.debug(error: SocialLoginError.noToken, message: "No Token")
                return ""
            }
            return token
        }
        return AccessTokenPlugin(tokenClosure: tokenClosure)
    }
}

private extension FitftyAPI {
    func updateParameters(_ parameter: [String: Any]) -> [String: Any] {
        return parameter
    }
}

public enum FitftyAPIError: LocalizedError {
    case notFound(String?)
    
    public var errorDescription: String? {
        switch self {
        case .notFound(let message): return message
        }
    }
}
