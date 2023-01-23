//
//  SocialLoginManager.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/01/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import KakaoSDKUser

public enum SocialLoginType {
    case apple
    case kakao
}

final public class SocialLoginManager {
    static public let shared = SocialLoginManager()
    
    var accessToken: String?
    var refreshToken: String?
    
    public func trySnsLogin(snsType: SocialLoginType,
                            completionHandler: @escaping () -> Void,
                            failedHandler: @escaping (Error) -> Void) {
        switch snsType {
        case .apple:
            tryAppleLogin(completionHandler: completionHandler, failedHandler: failedHandler)
        case .kakao:
            tryKakaoLogin(completionHandler: completionHandler, failedHandler: failedHandler)
        }
    }
    
    private func tryKakaoLogin(completionHandler: @escaping () -> Void,
                               failedHandler: @escaping (Error) -> Void) {
        guard isKakaoLoginAvailable() else {
            // TODO: - Error 처리해주자 - ethan
            return
        }
        
        UserApi.shared.loginWithKakaoTalk {[weak self] (oauthToken, error) in
            if let error = error {
                failedHandler(error)
            } else {
                self?.accessToken = oauthToken?.accessToken
                self?.refreshToken = oauthToken?.refreshToken
                
                completionHandler()
            }
        }
    }
    
    private func tryAppleLogin(completionHandler: @escaping () -> Void,
                               failedHandler: @escaping (Error) -> Void) {
        
    }
    
    private func isKakaoLoginAvailable() -> Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }
}
