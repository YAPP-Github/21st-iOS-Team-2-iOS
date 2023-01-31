//
//  AllReportView.swift
//  Profile
//
//  Created by 임영선 on 2023/01/31.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class AllReportView: UIStackView {
    
    private let reportViews: [ReportView] = [
        ReportView(title: "음란성 / 선정성 게시물"),
        ReportView(title: "날씨 태그가 사진과 어울리지 않음"),
        ReportView(title: "지적재산권 침해"),
        ReportView(title: "혐오 / 욕설 / 인신공격"),
        ReportView(title: "같은 내용 반복 게시"),
        ReportView(title: "기타 (team.fitfty@gmail.com로 제보)")
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStackView() {
        addArrangedSubviews(reportViews.map { $0 })
        self.distribution = .fill
        self.alignment = .fill
        self.axis = .vertical
        self.spacing = 23
    }

}
