//
//  DetailReportSection.swift
//  Profile
//
//  Created by 임영선 on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct DetailReportSection {
    let sectionKind: DetailReportSectionKind
    var items: [ReportCellModel]
}

public enum DetailReportSectionKind {
    case report

    init?(index: Int) {
        switch index {
        case 0: self = .report
        default: return nil
        }
    }
}

enum ReportCellModel: Hashable {
    case report(String, Bool)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .report(let title, let isSelected):
            hasher.combine(title)
            hasher.combine(isSelected)
        }
    }
}
