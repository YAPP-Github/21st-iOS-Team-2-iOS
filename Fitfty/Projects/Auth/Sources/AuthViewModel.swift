//
//  AuthViewModel.swift
//  Auth
//
//  Created by Watcha-Ethan on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common

final public class AuthViewModel: ViewModelType {
    public enum ViewModelState {
        case presentKakaoLoginView
        case pushOnboardingView
        case doSomething
    }
    
    public var state: PassthroughSubject<ViewModelState, Never> = .init()
    
    public init() {}
    
    func didTapKakaoLogin() {
        state.send(.presentKakaoLoginView)
    }
    
    func requestKakaoLogin() {
        // request API... Success !
        state.send(.pushOnboardingView)
    }
}
