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
    
    private lazy var userReportButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CommonAsset.Colors.error.color, for: .normal)
        button.setTitle("계정 신고", for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 18).font
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
        return button
    }()
    
    private let myPostBottomSheetView = MyPostBottomSheetView()
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator.dismiss()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: ReportCoordinatorInterface, reportType: ReportType) {
        self.coordinator = coordinator
        self.reportType = reportType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setConstraintsLayout()
        myPostBottomSheetView.setUpUserPost()
    }
    
    private func setConstraintsLayout() {
        switch reportType {
        case .userReport:
            view.addSubviews(userReportButton)
            NSLayoutConstraint.activate([
                userReportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                userReportButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
                userReportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        case .postUserReport:
            view.addSubviews(myPostBottomSheetView)
            NSLayoutConstraint.activate([
                myPostBottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                myPostBottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                myPostBottomSheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
            ])
        }
    
    }
    
    @objc func didTapReportButton(_ sender: Any?) {
        coordinator.showDetailReport()
    }
}
