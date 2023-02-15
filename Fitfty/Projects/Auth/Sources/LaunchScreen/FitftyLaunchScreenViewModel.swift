//
//  FitftyLaunchScreenViewModel.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/02/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine

import Core
import Common

final public class FitftyLaunchScreenViewModel: ViewModelType {
    public enum ViewModelState {
        case pushAuthView(needsIntroView: Bool)
        case pushMainFeedView
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    public init() {}
    
    func checkUserSession() {
        Task {
            try await Task.sleep(nanoseconds: 1 * 1000000000)
            let hasSession = await SessionManager.shared.checkUserSession()
            if hasSession {
                currentState.send(.pushMainFeedView)
            } else {
                checkNeedToShowIntroView()
            }
        }
    }
    
    private func checkNeedToShowIntroView() {
        let isNewUser = UserDefaults.standard.read(key: .isNewUser) as? Bool ?? true
        if isNewUser {
            UserDefaults.standard.write(key: .isNewUser, value: false)
            currentState.send(.pushAuthView(needsIntroView: true))
        } else {
            currentState.send(.pushAuthView(needsIntroView: false))
        }
    }
}
