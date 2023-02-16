//
//  ReportListViewModel.swift
//  Setting
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import UIKit
import Common
import Combine
import Core

protocol ReportListViewModelInput {
    
    var input: ReportListViewModelInput { get }
    func viewDidLoad()
  
}

public final class ReportListViewModel {
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var reportType: ReportType
    private var fitftyRepository: FitftyRepository
    
    public init(reportType: ReportType, fitftyRepository: FitftyRepository) {
        self.reportType = reportType
        self.fitftyRepository = fitftyRepository
    }
    
}

extension ReportListViewModel: ReportListViewModelInput {
    var input: ReportListViewModelInput { self }
    
    func viewDidLoad() {
        getReportList()
    }
    
}

extension ReportListViewModel: ViewModelType {
    
    public enum ViewModelState {
        case errorMessage(String)
        case sections([ReportListSection])
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
}

extension ReportListViewModel {
    
    func getReportList() {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                switch reportType {
                case .postReport:
                    let response = try await self.fitftyRepository.getPostReportList()
                    print(response)
                    guard response.result == "SUCCESS",
                          let data = response.data else {
                        return
                    }
                    var cellModels = [ReportListCellModel]()
                    for i in 0..<data.count {
                        cellModels.append(ReportListCellModel.report(data[i].reportUserEmail, data[i].type[0], String(data[i].reportedCount)))
                    }
                    self.currentState.send(.sections([ReportListSection(sectionKind: .report, items: cellModels)]))
                case .userReport:
                    let response = try await self.fitftyRepository.getUserReportList()
                    print(response)
                    guard response.result == "SUCCESS",
                          let data = response.data else {
                        return
                    }
                    var cellModels = [ReportListCellModel]()
                    for i in 0..<data.count {
                        cellModels.append(ReportListCellModel.report(data[i].reportedUserEmail, data[i].type[0], String(data[i].reportedCount)))
                    }
                    self.currentState.send(.sections([ReportListSection(sectionKind: .report, items: cellModels)]))
                }
            } catch {
                Logger.debug(error: error, message: "신고 리스트 조회 실패")
                self.currentState.send(.errorMessage("신고 리스트 조회에 알 수 없는 에러가 발생했습니다."))
            }
        }
    }
}
