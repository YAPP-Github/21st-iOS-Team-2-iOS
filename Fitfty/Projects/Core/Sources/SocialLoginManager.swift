//
//  SocialLoginManager.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/01/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import KakaoSDKUser
import AuthenticationServices

public enum SocialLoginType {
    case apple
    case kakao
}

final public class SocialLoginManager: NSObject {
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
    
    private func getUserInfo(completionHandler: @escaping () -> Void,
                             failedHandler: @escaping (Error) -> Void) {
       
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print(error)
            } else {
                if let user = user {
                    var scopes = [String]()
                    if (user.kakaoAccount?.profileNeedsAgreement == true) { scopes.append("profile") }
                    if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
                            
                    UserApi.shared.loginWithKakaoAccount(scopes: scopes) {[weak self] (oauthToken, error) in
                        if let error = error {
                            failedHandler(error)
                        } else {
                            self?.accessToken = oauthToken?.accessToken
                            self?.refreshToken = oauthToken?.refreshToken
                            
                            completionHandler()
                        }
                    }
                }
            }
        }
    }
    
    private func tryAppleLogin(completionHandler: @escaping () -> Void,
                               failedHandler: @escaping (Error) -> Void) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        
    }
    
    private func isKakaoLoginAvailable() -> Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }
}

extension SocialLoginManager: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let idToken = appleIDCredential.identityToken!
            let tokeStr = String(data: idToken, encoding: .utf8)
         
            print("userIdentifier: \(userIdentifier)")
            print("userEmail: \(email ?? "")")
            print("userName: \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            print("identityToken: \(String(describing: tokeStr))")
            
        default:
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

extension SocialLoginManager: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.keyWindow?.rootViewController?.view.window)!
    }
}
