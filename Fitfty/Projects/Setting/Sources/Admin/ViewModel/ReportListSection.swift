//
//  ReportListSection.swift
//  Setting
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct ReportListSection {
    let sectionKind: ReportListSectionKind
    var items: [ReportListCellModel]
}

public enum ReportListSectionKind {
    case report

    init?(index: Int) {
        switch index {
        case 0: self = .report
        default: return nil
        }
    }
    
}

public enum ReportListCellModel: Hashable {
    case report(String, String, String, String?)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .report(let account, let detailReport, let count, let filepath):
            hasher.combine(account)
            hasher.combine(detailReport)
            hasher.combine(count)
            hasher.combine(filepath)
        }
    }
}
