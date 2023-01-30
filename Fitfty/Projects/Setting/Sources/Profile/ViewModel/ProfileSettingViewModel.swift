//
//  ProfileSettingViewModel.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import Combine

public final class ProfileSettingViewModel {

    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)

    public init() {}

}

extension ProfileSettingViewModel: ViewModelType {
    public enum ViewModelState {}
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
}
