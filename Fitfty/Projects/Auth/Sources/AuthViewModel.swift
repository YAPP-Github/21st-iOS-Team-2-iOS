//
//  AuthViewModel.swift
//  Auth
//
//  Created by Watcha-Ethan on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation
import Combine

import Core
import Common

final public class AuthViewModel: ViewModelType {
    public enum ViewModelState {
        case pushIntroView
        case pushMainFeedView
        case showErrorAlert(_ error: Error)
    }
    
    public var state: PassthroughSubject<ViewModelState, Never> = .init()
    
    public init() {}
    
    func didTapKakaoLogin() {
        SocialLoginManager.shared.trySnsLogin(
            snsType: .kakao,
            completionHandler: { [weak self] in
                // TODO: - 서버 연동되면 계정 유무 체크해서 바로 메인피드로 보낼지 회원가입 루트 탈지 분기 처리하자 - ethan
                self?.state.send(.pushIntroView)
            },
            failedHandler: { [weak self] error in
                self?.state.send(.showErrorAlert(error))
            }
        )
    }
    
    func didTapAppleLogin() {
        
    }
    
    func didTapEnterWithoutLoginButton() {
        state.send(.pushIntroView)
    }
}
