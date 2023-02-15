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
        case pushPermissionView
        case pushMainFeedView
        case showErrorAlert(_ error: Error)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    public init() {}
    
    func didTapKakaoLogin() {
        SocialLoginManager.shared.tryKakaoLogin(completionHandler: { [weak self] isNewUser in
            if isNewUser {
                self?.currentState.send(.pushPermissionView)
            } else {
                self?.currentState.send(.pushMainFeedView)
            }
        }, failedHandler: { [weak self] error in
            self?.currentState.send(.showErrorAlert(error))
        })
    }
    
    func didTapAppleLogin() {
        SocialLoginManager.shared.tryAppleLogin(completionHandler: { [weak self] isNewUser in
            if isNewUser {
                self?.currentState.send(.pushPermissionView)
            } else {
                self?.currentState.send(.pushMainFeedView)
            }
        }, failedHandler: { [weak self] error in
            self?.currentState.send(.showErrorAlert(error!))
        })
    }
    
    func didTapEnterWithoutLoginButton() {
        currentState.send(.pushMainFeedView)
    }
}
