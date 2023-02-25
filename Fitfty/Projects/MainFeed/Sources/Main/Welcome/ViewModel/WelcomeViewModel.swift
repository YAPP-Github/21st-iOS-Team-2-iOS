//
//  WelcomeViewModel.swift
//  MainFeed
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common
import Core

protocol WelcomeViewModelInput {
    
    var input: WelcomeViewModelInput { get }
    
    func viewDidLoad()
    
    func didTapStart()
}

public final class WelcomeViewModel {

    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private let fitftyRepository: FitftyRepository
    private let userManager: UserManager
    
    public init(
        fitftyRepository: FitftyRepository,
        userManager: UserManager
    ) {
        self.fitftyRepository = fitftyRepository
        self.userManager = userManager
    }

}

extension WelcomeViewModel: WelcomeViewModelInput {
    
    var input: WelcomeViewModelInput { self }
    
    func viewDidLoad() {
        Task {
            do {
                let response = try await fitftyRepository.fetchMyInfo()
                if let data = response.data {
                    currentState.send(.nickName(data.nickname))
                } else {
                    Logger.debug(error: MainFeedError.tagLoadFailed, message: MainFeedError.tagLoadFailed.errorDescription ?? "")
                }
            } catch {
                Logger.debug(error: error, message: "태그 설정 조회 실패")
            }
        }
    }
    
    func didTapStart() {
        userManager.updateCompletedWelcomePage()
    }
    
}

extension WelcomeViewModel: ViewModelType {
    public enum ViewModelState {
        case nickName(String)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
}
