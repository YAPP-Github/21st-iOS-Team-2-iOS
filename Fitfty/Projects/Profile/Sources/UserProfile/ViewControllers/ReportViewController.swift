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
    
    let coordinator: UserProfileCoordinatorInterface
    
    private lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 신고", for: .normal)
        button.setTitleColor(CommonAsset.Colors.error.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 18).font
        button.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public init(coordinator: UserProfileCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        setConstraintsLayout()
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
    
    @objc func didTapReportButton(_ sender: Any?) {
        coordinator.dismissReport(self)
    }
}
