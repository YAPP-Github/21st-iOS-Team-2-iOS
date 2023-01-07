//
//  UploadCodyViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final public class UploadCodyViewController: UIViewController {
    
    private var coordinator: UploadCodyCoordinatorInterface
    
    private let topBarView = TopBarView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintLayout()
        setUpButtonAction()
    }

    public init(coordinator: UploadCodyCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintLayout() {
        view.addSubviews(topBarView)
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            topBarView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func setUpButtonAction() {
        topBarView.addTargetCancelButton(self, action: #selector(didTapCancelButton))
        topBarView.addTargetUploadButton(self, action: #selector(didTapUploadButton))
    }
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        coordinator.dismissUploadCody(self)
    }
    
    @objc func didTapUploadButton(_ sender: UIButton) {
        topBarView.setEnableUploadButton()
    }
}
