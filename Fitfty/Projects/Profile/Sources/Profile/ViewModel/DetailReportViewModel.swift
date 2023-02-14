//
//  DetailReportViewModel.swift
//  Profile
//
//  Created by 임영선 on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import Combine
import Core

protocol DetailReportViewModelInput {
    
    var input: DetailReportViewModelInput { get }
    func didTapTitle(index: Int)
    func viewDidLoad()
    func didTapReportButton()
}

public final class DetailReportViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var userManager: UserManager
    private var reports: [(detailReportType: DetailReportType, isSelected: Bool)] = [
        (.OBSCENE, false),
        (.WEATHER, false),
        (.COPYRIGHT, false),
        (.INSULT, false),
        (.REPEAT, false),
        (.MISC, false)
    ]
    
    public init(userManager: UserManager) {
        self.userManager = userManager
    }
    
}

extension DetailReportViewModel: DetailReportViewModelInput {
    var input: DetailReportViewModelInput { self }
    
    func didTapTitle(index: Int) {
        var reportCellModels = [ReportCellModel]()
        for i in 0..<reports.count {
            reports[i].isSelected =  i == index ? true : false
            reportCellModels.append(ReportCellModel.report(reports[i].detailReportType.koreanDetailReport, reports[i].isSelected))
        }
        
        currentState.send(.sections([
            DetailReportSection(
                sectionKind: .report,
                items: reportCellModels
            )
        ]))
    }
    
    func didTapReportButton() {
        if reports.filter({ $0.isSelected }).count < 1 {
            currentState.send(.completed(false))
        } else {
            guard let report = reports.filter({ $0.isSelected }).first?.detailReportType.englishDetailReport else {
                return
            }
            print([report])
        }
    }
    
    func viewDidLoad() {
        var reportCellModels = [ReportCellModel]()
        for i in 0..<reports.count {
            reportCellModels.append(ReportCellModel.report(reports[i].detailReportType.koreanDetailReport, reports[i].isSelected))
        }
        currentState.send(.sections([
            DetailReportSection(
                sectionKind: .report,
                items: reportCellModels
            )
        ]))
    }
    
}

extension DetailReportViewModel: ViewModelType {
    
    public enum ViewModelState {
        case isLoading(Bool)
        case errorMessage(String)
        case completed(Bool)
        case sections([DetailReportSection])
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
}
