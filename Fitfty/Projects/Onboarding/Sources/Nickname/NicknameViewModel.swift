//
//  NicknameViewModel.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine

import Common
import Core

final public class NicknameViewModel: ViewModelType {
    public enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
        case pushGenderView
    }
    
    private let repository: OnboardingRepository
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    @Published var hasAvailableString = false
    @Published var hasNoOverlappingNickname = false
    private var nickname = ""
    private var isEnabledNextButton: Bool {
        return hasAvailableString && hasNoOverlappingNickname
    }
    
    public init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    func checkNicknameAvailable(_ nickname: String) {
        hasAvailableString(nickname)
    }
    
    func didTapNextButton() {
        UserDefaults.standard.write(key: .nickname, value: nickname)
        currentState.send(.pushGenderView)
    }
}

private extension NicknameViewModel {
    private func hasAvailableString(_ nickname: String) {
        self.nickname = nickname
        let regex = "^[0-9a-zA-Z]{6,30}$"
        if nickname.range(of: regex, options: .regularExpression) != nil {
            hasAvailableString = true
            hasNoOverlappingNickname(nickname)
        } else {
            hasAvailableString = false
            hasNoOverlappingNickname = false
            checkEnabledNextButton()
        }
    }
    
    private func hasNoOverlappingNickname(_ nickname: String) {
        Task {
            do {
                let result = try await repository.checkNickname(nickname)
                hasNoOverlappingNickname = result ? true : false
                checkEnabledNextButton()
            } catch {
                hasNoOverlappingNickname = false
            }
        }
    }
    
    private func checkEnabledNextButton() {
        if isEnabledNextButton {
            currentState.send(.changeNextButtonState(isEnabled: true))
        } else {
            currentState.send(.changeNextButtonState(isEnabled: false))
        }
    }
}
