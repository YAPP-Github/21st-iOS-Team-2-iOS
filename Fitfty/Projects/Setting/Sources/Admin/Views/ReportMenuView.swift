//
//  ReportMenuView.swift
//  Setting
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class ReportMenuView: UIView {
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplayBlack(size: 15).font
        return label
    }()
    
    private lazy var detailReportLabel: UILabel = {
        let label = UILabel()
        label.text = "신고 사유"
        label.font = FitftyFont.SFProDisplayBlack(size: 15).font
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "신고 횟수"
        label.font = FitftyFont.SFProDisplayBlack(size: 15).font
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(emailLabel, detailReportLabel, countLabel)
        NSLayoutConstraint.activate([
            emailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailReportLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailReportLabel.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 130),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: detailReportLabel.trailingAnchor, constant: 50)
        ])
    }
}

extension ReportMenuView {
    
    func setUp(reportType: ReportType) {
        switch reportType {
        case .postReport:
            emailLabel.text = "사진"
        case .userReport:
            emailLabel.text = "계정"
        }
    }
}
