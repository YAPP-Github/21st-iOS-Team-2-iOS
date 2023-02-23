//
//  ReportViewModel.swift
//  Profile
//
//  Created by 임영선 on 2023/02/23.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import Combine
import Core

protocol ReportViewModelInput {
    
    var input: ReportViewModelInput { get }
    func didTapBlockButton()
}

public final class ReportViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var userManager: UserManager
    private var userToken: String?
    private var boardToken: String?
    private var reportType: ReportType
    private var fitftyRepository: FitftyRepository
    
    public init(
        userManager: UserManager,
        userToken: String?,
        boardToken: String?,
        reportType: ReportType,
        fitftyRepository: FitftyRepository
    ) {
        self.userManager = userManager
        self.userToken = userToken
        self.boardToken = boardToken
        self.reportType = reportType
        self.fitftyRepository = fitftyRepository
    }
    
}

extension ReportViewModel: ReportViewModelInput {
    
    var input: ReportViewModelInput { self }
    
    func didTapBlockButton() {
        if userManager.getCurrentGuestState() {
            currentState.send(.errorMessage("로그인이 필요합니다."))
        } else {
            report()
        }
    }
    
}

extension ReportViewModel: ViewModelType {
    
    public enum ViewModelState {
        case errorMessage(String)
        case completed(Bool)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
}

private extension ReportViewModel {
    
    func report() {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                switch reportType {
                case .postReport:
                    guard let boardToken = boardToken else {
                        return
                    }
                    let request = PostReportRequest(
                        reportedBoardToken: boardToken,
                        type: ["INSULT"]
                    )
                    let response = try await self.fitftyRepository.report(request)
                    guard response.result == "SUCCESS" else {
                        return
                    }
                    self.currentState.send(.completed(true))
                    
                case .userReport:
                    guard let userToken = userToken else {
                        return
                    }
                    let request = UserReportRequest(
                        reportedUserToken: userToken,
                        type: ["INSULT"]
                    )
                    let response = try await self.fitftyRepository.report(request)
                    guard response.result == "SUCCESS" else {
                        return
                    }
                    self.currentState.send(.completed(true))
                }
                
            } catch {
                Logger.debug(error: error, message: "신고하기 실패")
                self.currentState.send(.errorMessage("신고에 알 수 없는 에러가 발생했습니다."))
            }
        }
    }
    
}
