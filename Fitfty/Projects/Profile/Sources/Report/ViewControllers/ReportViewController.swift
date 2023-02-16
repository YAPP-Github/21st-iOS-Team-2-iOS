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
    let reportPresentType: ReportPresentType
    var userToken: String?
    var boardToken: String?
    
    private lazy var userReportButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CommonAsset.Colors.error.color, for: .normal)
        button.setTitle("계정 신고", for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 18).font
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(didTapUserReportButton), for: .touchUpInside)
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
    
    public init(
        coordinator: ReportCoordinatorInterface,
        reportPresentType: ReportPresentType,
        userToken: String?,
        boardToken: String?
    ) {
        self.coordinator = coordinator
        self.reportPresentType = reportPresentType
        self.userToken = userToken
        self.boardToken = boardToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setConstraintsLayout()
        
    }
    
    private func setConstraintsLayout() {
        switch reportPresentType {
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
            myPostBottomSheetView.setUpUserPost()
            myPostBottomSheetView.setActionFirstButton(self, action: #selector(didTapUserReportButton))
            myPostBottomSheetView.setActionSecondButton(self, action: #selector(didTapPostReportButton))
        }
    
    }
    
    @objc func didTapUserReportButton(_ sender: Any?) {
        coordinator.showDetailReport(.userReport, userToken: userToken, boardToken: boardToken)
    }
    
    @objc func didTapPostReportButton(_ sender: Any?) {
        coordinator.showDetailReport(.postReport, userToken: userToken, boardToken: boardToken)
    }
    
}
