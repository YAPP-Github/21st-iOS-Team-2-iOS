//
//  CodyCellViewModel.swift
//  MainFeed
//
//  Created by Ari on 2023/02/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common
import Core

protocol CodyCellViewModelInput {
    var input: CodyCellViewModelInput { get }
    func fetch()
    func didTapBookmark()
}

final class CodyCellViewModel {
    
    private let cody: CodyResponse
    private let fitftyRepository: FitftyRepository
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var isBookmark: Bool
    
    init(fitftyRepository: FitftyRepository, cody: CodyResponse) {
        self.fitftyRepository = fitftyRepository
        self.cody = cody
        self.isBookmark = cody.bookmarked
    }
    
}

extension CodyCellViewModel: ViewModelType {
    enum ViewModelState {
        case cody(CodyResponse)
        case bookmarkState(Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
}

extension CodyCellViewModel: CodyCellViewModelInput {
    var input: CodyCellViewModelInput { self }
    
    func fetch() {
        currentState.send(.cody(cody))
    }
    
    func didTapBookmark() {
        self.isBookmark = !isBookmark
        currentState.send(.bookmarkState(isBookmark))
        requestBookmark()
    }
}

private extension CodyCellViewModel {
    
    func requestBookmark() {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let response = try await fitftyRepository.bookmark(self.isBookmark, boardToken: self.cody.boardToken)
                if response.result == .fail {
                    let error = ViewModelError.failure(errorCode: response.errorCode ?? "", message: response.message ?? "")
                    Logger.debug(error: error, message: "북마크 업데이트 실패")
                }
            } catch {
                Logger.debug(error: error, message: "북마크 업데이트 실패")
            }
        }
    }
    
}