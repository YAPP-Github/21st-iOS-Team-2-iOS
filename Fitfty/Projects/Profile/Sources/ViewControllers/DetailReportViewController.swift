//
//  DetailReportViewController.swift
//  Profile
//
//  Created by 임영선 on 2023/01/31.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class DetailReportViewController: UIViewController {
    
    let coordinator: DetailReportCoordinatorInterface
    private let allReportView = AllReportView()
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView(title: "신고 사유", isChevronButtonHidden: true)
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return barView
    }()
    
    private lazy var cancelButton: FitftyButton = {
        let button = FitftyButton(style: .enabled, title: "신고하기")
        button.setButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setConstraintsLayout()
    }
    
    public init(coordinator: DetailReportCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        view.addSubviews(navigationBarView, allReportView, cancelButton)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 76),
            
            allReportView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            allReportView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            allReportView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: 10),
           
            cancelButton.topAnchor.constraint(equalTo: allReportView.bottomAnchor, constant: 35),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func didTapCancelButton(_ sender: UITapGestureRecognizer) {
        coordinator.dismiss()
    }
    
}
