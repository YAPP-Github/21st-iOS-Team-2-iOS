//
//  GenderViewModel.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine

import Common
import Core

final public class GenderViewModel: ViewModelType {
    public enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
        case pushStyleView
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    @Published var maleButtonIsPressed = false
    @Published var femaleButtonIsPressed = false
    
    public init() {}
    
    func didTapNextButton() {
        UserDefaults.standard.write(key: .gender, value: "")
        currentState.send(.pushStyleView)
    }
}
