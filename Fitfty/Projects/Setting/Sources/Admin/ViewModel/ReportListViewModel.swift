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

private extension ReportListViewModel {
    
    func getReportList() {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                switch reportType {
                case .postReport:
                    guard let data = try await getPostReportList() else {
                        return
                    }
                    self.currentState.send(.sections([ReportListSection(sectionKind: .report, items: getCellModels(data))]))
                    
                case .userReport:
                    guard let data = try await getUserReportList() else {
                        return
                    }
                    self.currentState.send(.sections([ReportListSection(sectionKind: .report, items: getCellModels(data))]))
                }
            } catch {
                Logger.debug(error: error, message: "신고 리스트 조회 실패")
                self.currentState.send(.errorMessage("신고 리스트 조회에 알 수 없는 에러가 발생했습니다."))
            }
        }
    }
    
    func getPostReportList() async throws -> [PostReportListData]? {
        let response = try await self.fitftyRepository.getPostReportList()
        if response.result == "SUCCESS" {
            return response.data
        } else {
            return nil
        }
    }
    
    func getUserReportList() async throws -> [UserReportListData]? {
        let response = try await self.fitftyRepository.getUserReportList()
        if response.result == "SUCCESS" {
            return response.data
        } else {
            return nil
        }
    }
    
    func getCellModels(_ data: [PostReportListData]) -> [ReportListCellModel] {
        var cellModels = [ReportListCellModel]()
        for i in 0..<data.count {
            cellModels.append(ReportListCellModel.report(data[i].reportUserEmail, getKoreanDetailReport(data[i].type[0]), String(data[i].reportedCount+1), data[i].reportedBoardFilePath))
        }
        return cellModels
    }
    
    func getCellModels(_ data: [UserReportListData]) -> [ReportListCellModel] {
        var cellModels = [ReportListCellModel]()
        for i in 0..<data.count {
            cellModels.append(ReportListCellModel.report(data[i].reportedUserEmail, getKoreanDetailReport(data[i].type[0]), String(data[i].reportedCount+1), nil))
        }
        return cellModels
    }
    
    func getKoreanDetailReport(_ english: String) -> String {
        switch english {
        case "OBSCENE": return "음란성/선정성"
        case "WEATHER": return "날씨와맞지않음"
        case "COPYRIGHT": return "지적재산권침해"
        case "INSULT": return "혐오/욕설/인신공격"
        case "REPEAT": return "같은내용반복"
        default: return "기타"
        }
    }
    
}
