//
//  SocialLoginManager.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/01/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

final public class SocialLoginManager: NSObject {
    static public let shared = SocialLoginManager()
    
    private override init() {}
    
    public func tryAppleLogin(completionHandler: @escaping (Bool) -> Void,
                              failedHandler: @escaping (Error?) -> Void) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        _ = ASAuthorizationController(requests: [request],
                                          completionHandler: completionHandler,
                                          failedHandler: failedHandler)
    }
    
    public func tryKakaoLogin(completionHandler: @escaping (Bool) -> Void,
                              failedHandler: @escaping (Error) -> Void) {
        if isKakaoLoginAvailable() {
            loginWithKakaoAccount(completionHandler: completionHandler,
                                  failedHandler: failedHandler)
        } else {
            loginWithKakaoTalk(completionHandler: completionHandler,
                               failedHandler: failedHandler)
        }
    }
    
    public func initailizeKakaoLoginSDK() {
        KakaoSDK.initSDK(appKey: APIKey.kakaoAppKeyForLogin)
    }
    
    private func loginWithKakaoTalk(completionHandler: @escaping (Bool) -> Void,
                                    failedHandler: @escaping (Error) -> Void) {
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, _) in
            if let accessToken = oauthToken?.accessToken {
                self?.saveKakaoUserInfo()
                self?.requestKakaoLogin(accessToken,
                                        completionHandler: completionHandler,
                                        failedHandler: failedHandler)
            } else {
                failedHandler(SocialLoginError.noKakaoAvailable)
            }
        }
    }
    
    private func loginWithKakaoAccount(completionHandler: @escaping (Bool) -> Void,
                                       failedHandler: @escaping (Error) -> Void) {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, _) in
            if let accessToken = oauthToken?.accessToken {
                self?.saveKakaoUserInfo()
                self?.requestKakaoLogin(accessToken,
                                        completionHandler: completionHandler,
                                        failedHandler: failedHandler)
            } else {
                failedHandler(SocialLoginError.noKakaoAvailable)
            }
        }
    }
    
    private func requestKakaoLogin(_ accessToken: String,
                                   completionHandler: @escaping (Bool) -> Void,
                                   failedHandler: @escaping (Error) -> Void) {
        Task {
            do {
                let response = try await FitftyAPI.request(target: .signInKakao(parameters: ["accessToken": accessToken]),
                                                           dataType: SocialLoginResponse.self)
                guard let jwt = response.data?.authToken else {
                    checkNoEmailErrorFromKakao(errorCode: response.errorCode, failedHandler: failedHandler)
                    failedHandler(SocialLoginError.others(response.message ?? ""))
                    return
                }
                
                if let userIdentifier = UserDefaults.standard.read(key: .userIdentifier) as? String,
                   let userAccount = UserDefaults.standard.read(key: .userAccount) as? String {
                    Keychain.saveData(serviceIdentifier: userIdentifier, forKey: userAccount, data: jwt)
                }
                
                if response.data?.isNew == true {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            } catch {
                failedHandler(SocialLoginError.loginFail)
            }
        }
    }
    
    private func saveKakaoUserInfo() {
        UserApi.shared.me() { (user, error) in
            if let user = user,
               let identifier = user.id,
               let account = user.kakaoAccount?.email {
                UserDefaults.standard.write(key: .userIdentifier, value: String(identifier))
                UserDefaults.standard.write(key: .userAccount, value: account)
            }
        }
    }

    private func isKakaoLoginAvailable() -> Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }
    
    private func checkNoEmailErrorFromKakao(errorCode: String?, failedHandler: @escaping (Error) -> Void) {
        if errorCode == "KAKAO_OAUTH_NO_RESPONSE" {
            UserApi.shared.unlink { error in
                if let error = error {
                    failedHandler(error)
                }
            }
        }
    }
}

// MARK: - Apple Login

extension ASAuthorizationController {
    fileprivate typealias AppleLoginCompletionHandler = (Bool) -> Void
    fileprivate typealias AppleLoginFailedHandler = (Error?) -> Void
    
    private struct AssociatedKeys {
        static var completionHandler = "CompletionHandler"
        static var failedHandler = "FailedHandler"
    }
    
    private var completionHandler: AppleLoginCompletionHandler? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.completionHandler) as? AppleLoginCompletionHandler
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.completionHandler, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    private var failedHandler: AppleLoginFailedHandler? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.failedHandler) as? AppleLoginFailedHandler
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.failedHandler, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    convenience fileprivate init(requests: [ASAuthorizationRequest],
                                 completionHandler: AppleLoginCompletionHandler?,
                                 failedHandler: AppleLoginFailedHandler?) {
        self.init(authorizationRequests: requests)
        self.completionHandler = completionHandler
        self.failedHandler = failedHandler
        self.delegate = self
        self.presentationContextProvider = self
        self.performRequests()
    }
    
    private func hasEmail(email: String?) -> Bool {
        return email?.isEmpty == false
    }
    
    private func requestAppleLogin(_ request: AppleLoginRequest) {
        Task {
            do {
                let response = try await FitftyAPI.request(target: .signInApple(parameters: request.asDictionary()),
                                                           dataType: SocialLoginResponse.self)
                guard let jwt = response.data?.authToken else {
                    failedHandler?(SocialLoginError.others(response.message ?? ""))
                    return
                }
                
                UserDefaults.standard.write(key: .userIdentifier, value: request.userIdentifier)
                UserDefaults.standard.write(key: .userAccount, value: request.userEmail)
                Keychain.saveData(serviceIdentifier: request.userIdentifier, forKey: request.userEmail, data: jwt)

                if response.data?.isNew == true {
                    completionHandler?(true)
                } else {
                    completionHandler?(false)
                }
            } catch {
                failedHandler?(SocialLoginError.loginFail)
            }
        }
    }
}

extension ASAuthorizationController: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {
        var userIdentifier: String = ""
        var fullName: String = ""
        var email: String = ""
        var identityToken: String = ""
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let idToken = appleIDCredential.identityToken!
            let personName = appleIDCredential.fullName
            
            userIdentifier = appleIDCredential.user
            fullName = "\(personName?.familyName ?? "")" + "\(personName?.givenName ?? "")"
            email = appleIDCredential.email ?? ""
            identityToken = String(data: idToken, encoding: .utf8) ?? ""
        default:
            break
        }
        
        let request = AppleLoginRequest(userIdentifier: userIdentifier,
                                        userName: fullName,
                                        userEmail: email,
                                        identityToken: identityToken)
        requestAppleLogin(request)
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        failedHandler?(error)
    }
}

extension ASAuthorizationController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.keyWindow?.rootViewController?.view.window)!
    }
}
