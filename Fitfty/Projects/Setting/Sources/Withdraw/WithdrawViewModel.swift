//
//  WithdrawViewModel.swift
//  Setting
//
//  Created by Watcha-Ethan on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine

import Common
import Core

final public class WithdrawViewModel: ViewModelType {
    public enum ViewModelState {
        case pushWithdrawConfirmView
        case showErrorAlert(_ error: Error)
    }
    
    private let repository: SettingRepository

    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    public init(repository: SettingRepository) {
        self.repository = repository
    }
    
    func didTapWithdrawButton() {
        Task {
            do {
                let response = try await repository.withdrawAccount()
                if response {
                    repository.logout()
                    currentState.send(.pushWithdrawConfirmView)
                } else {
                    currentState.send(.showErrorAlert(SettingError.failWithdrawAccount))
                }
            } catch {
                currentState.send(.showErrorAlert(error))
            }
        }
    }
}
