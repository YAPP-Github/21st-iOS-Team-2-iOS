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
    
}

public final class DetailReportViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var reports: [(title: String, isSelected: Bool)] = [
        ("음란성 / 선정성 게시물", false),
        ("날씨 태그가 사진과 어울리지 않음", false),
        ("지적재산권 침해", false),
        ("혐오 / 욕설 / 인신공격", false),
        ("같은 내용 반복 게시", false),
        ("기타", false)
    ]
    public init() { }
    
}

extension DetailReportViewModel: DetailReportViewModelInput {
    var input: DetailReportViewModelInput { self }
    
    func didTapTitle(index: Int) {
        var reportCellModels = [ReportCellModel]()
        for i in 0..<reports.count {
            reports[i].isSelected =  i == index ? true : false
            reportCellModels.append(ReportCellModel.report(reports[i].title, reports[i].isSelected))
        }
        
        currentState.send(.sections([
            DetailReportSection(
                sectionKind: .report,
                items: reportCellModels
            )
        ]))
    }
    
    func viewDidLoad() {
        var reportCellModels = [ReportCellModel]()
        for i in 0..<reports.count {
            reportCellModels.append(ReportCellModel.report(reports[i].title, reports[i].isSelected))
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
