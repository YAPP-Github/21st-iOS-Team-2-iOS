//
//  ReportListViewController.swift
//  Setting
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class ReportListViewController: UIViewController {
    
    private let menuView = ReportMenuView()
    private var coordinator: ReportListCoordinatorInterface
    
    public init(coordinator: ReportListCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
  
    private func setUp() {
        setConstraintsLayout()
        setNavigationBar()
    }
    
    @objc func didTapBackButton(_ sender: Any?) {
        coordinator.dismiss()
    }
    
}

private extension ReportListViewController {
    
    func setConstraintsLayout() {
        view.addSubviews(menuView)
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            menuView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            menuView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false
       
        let cancelButton = UIBarButtonItem(
                image: CommonAsset.Images.btnArrowleft.image,
                style: .plain,
                target: self,
                action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
    }
    
}
