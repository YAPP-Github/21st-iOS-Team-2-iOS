//
//  ReportViewController.swift
//  Profile
//
//  Created by 임영선 on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class ReportViewController: UIViewController {
    
    let coordinator: ReportCoordinatorInterface
    let reportType: ReportType
    
    private lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CommonAsset.Colors.error.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 18).font
        button.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
        return button
    }()
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator.dismiss()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setConstraintsLayout()
        setTitle()
    }
    
    public init(coordinator: ReportCoordinatorInterface, reportType: ReportType) {
        self.coordinator = coordinator
        self.reportType = reportType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        view.addSubviews(reportButton)
        NSLayoutConstraint.activate([
            reportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reportButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 44)
        ])
       
    }
    
    private func setTitle() {
        switch reportType {
        case .userReport:
            reportButton.setTitle("계정 신고", for: .normal)
        case .postReport:
            reportButton.setTitle("게시글 신고", for: .normal)
        }
    }
    
    @objc func didTapReportButton(_ sender: Any?) {
        coordinator.showDetailReport(myUserToken: "zz", otherUserToken: "zzz")
    }
}
