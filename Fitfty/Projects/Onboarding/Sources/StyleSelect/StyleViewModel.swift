//
//  StyleViewModel.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine

import Common
import Core

final public class StyleViewModel: ViewModelType {
    public enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
        case pushMainFeedView
        case showErrorAlert(_ error: Error)
    }
    
    private let repository: OnboardingRepository
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    private var styles: [StyleTag] = []
    private var isEnabledNextButton: Bool {
        return styles.count >= 2
    }
    
    public init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    func setUserDetails(completionHandler: @escaping () -> Void) {
        let styles = styles.map({ $0.styleTagEnglishString })
        guard let nickname = UserDefaults.standard.read(key: .nickname) as? String,
              let gender = UserDefaults.standard.read(key: .gender) as? String else {
            currentState.send(.showErrorAlert(OnboardingError.noUserData))
            return
        }
        
        Task {
            do {
                try await repository.setUserDetails(nickname: nickname,
                                                    gender: gender,
                                                    styles: styles)
                completionHandler()
            } catch {
                currentState.send(.showErrorAlert(OnboardingError.others(error.localizedDescription)))
            }
        }
    }
    
    func didTapNextButton() {
        setUserDetails { [weak self] in
            self?.currentState.send(.pushMainFeedView)
        }
    }
    
    func didSelectItem(style: StyleTag, isSelected: Bool) {
        if isSelected {
            styles.append(style)
        } else {
            styles.removeAll(where: { $0 == style })
        }
        
        checkEnabledNextButton()
    }
    
    private func checkEnabledNextButton() {
        if isEnabledNextButton {
            currentState.send(.changeNextButtonState(isEnabled: true))
        } else {
            currentState.send(.changeNextButtonState(isEnabled: false))
        }
    }
}
