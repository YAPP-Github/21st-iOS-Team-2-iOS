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

final public class SocialLoginManager: NSObject {
    static public let shared = SocialLoginManager()
    
    var accessToken: String?
    var refreshToken: String?
    
    public func tryKakaoLogin(completionHandler: @escaping () -> Void,
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
                completionHandler()
            }
        }
    }
    
    public func tryAppleLogin(completionHandler: @escaping (_ request: AppleLoginRequest) -> Void,
                               failedHandler: @escaping (Error?) -> Void) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(requests: [request],
                                                                completionHandler: completionHandler,
                                                                failedHandler: failedHandler)
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

                    // 이메일 nil이면 에러 처리
                    
                    UserApi.shared.loginWithKakaoAccount(scopes: scopes) {[weak self] (oauthToken, error) in
                        if let error = error {
                            failedHandler(error)
                        } else {
                            self?.accessToken = oauthToken?.accessToken
                            completionHandler()
                        }
                    }
                }
            }
        }
    }

    private func isKakaoLoginAvailable() -> Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }
}

extension ASAuthorizationController {
    fileprivate typealias AppleLoginCompletionHandler = (_ request: AppleLoginRequest) -> Void
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
}

extension ASAuthorizationController: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {
        var userIdentifier: String?
        var fullName: String?
        var email: String?
        var identityToken: String?
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let idToken = appleIDCredential.identityToken!
            let personName = appleIDCredential.fullName
            
            userIdentifier = appleIDCredential.user
            fullName = "\(personName?.familyName ?? "")" + "\(personName?.givenName ?? "")"
            email = appleIDCredential.email
            identityToken = String(data: idToken, encoding: .utf8)
        default:
            break
        }
        
        guard hasEmail(email: email) else {
            // noEmailError
            return
        }
        
        let request = AppleLoginRequest(userIdentifier: userIdentifier,
                                        fullName: fullName,
                                        email: email,
                                        identityToken: identityToken)
        
        completionHandler?(request)
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        failedHandler?(error)
    }
    
    private func hasEmail(email: String?) -> Bool {
        return email?.isEmpty == false
    }
}

extension ASAuthorizationController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.keyWindow?.rootViewController?.view.window)!
    }
}

public struct AppleLoginRequest {
    let userIdentifier: String?
    let fullName: String?
    let email: String?
    let identityToken: String?
}
