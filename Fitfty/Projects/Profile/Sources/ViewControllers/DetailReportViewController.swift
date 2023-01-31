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
    
    let coordinator: ProfileCoordinatorInterface
    
   private let allReportView = AllReportView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public init(coordinator: ProfileCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        setConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        view.addSubviews(allReportView)
        NSLayoutConstraint.activate([
            allReportView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            allReportView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            allReportView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            allReportView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
}

