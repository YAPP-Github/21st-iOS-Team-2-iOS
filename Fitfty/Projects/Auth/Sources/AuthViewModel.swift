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

final public class AuthViewModel {
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    public init() {}
    
    func didTapKakaoLogin() {
        currentState.send(.presentKakaoLoginView)
    }
    
    func requestKakaoLogin() {
        // request API... Success !
        currentState.send(.pushOnboardingView)
    }
}

extension AuthViewModel: ViewModelType {
    public enum ViewModelState {
        case presentKakaoLoginView
        case pushOnboardingView
        case doSomething
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
}
