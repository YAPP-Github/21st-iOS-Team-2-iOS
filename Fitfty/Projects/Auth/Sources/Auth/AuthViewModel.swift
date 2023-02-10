//
//  AuthViewModel.swift
//  Auth
//
//  Created by Watcha-Ethan on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation
import Combine
import AuthenticationServices

import Core
import Common

final public class AuthViewModel: ViewModelType {
    public enum ViewModelState {
        case pushIntroView
        case pushMainFeedView
        case showErrorAlert(_ error: Error)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    public init() {}
    
    func didTapKakaoLogin() {
        SocialLoginManager.shared.tryKakaoLogin( completionHandler: { [weak self] in
            /// - TODO: 카카오/애플 소셜로그인 후에 온보딩을 정상적으로 마치고 회원가입한 유저인지 판단할 수 있는 값이 생기면
            /// > 인트로로 보내줄지
            /// > 바로 메인피드로 보내줄지 대응
            self?.currentState.send(.pushIntroView)
        }, failedHandler: { [weak self] error in
            self?.currentState.send(.showErrorAlert(error))
        })
    }
    
    func didTapAppleLogin() {
        SocialLoginManager.shared.tryAppleLogin(completionHandler: { [weak self] in
            self?.currentState.send(.pushIntroView)
        }, failedHandler: { [weak self] error in
            self?.currentState.send(.showErrorAlert(error!))
        })
    }
    
    func didTapEnterWithoutLoginButton() {
        currentState.send(.pushMainFeedView)
    }
}
