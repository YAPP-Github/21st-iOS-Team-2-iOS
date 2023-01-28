//
//  ProfileSettingViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public final class ProfileSettingViewController: UIViewController {
    
    private weak var coordinator: ProfileSettingCoordinatorInterface?
    private var viewModel: ProfileSettingViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: ProfileSettingCoordinatorInterface, viewModel: ProfileSettingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView(title: "프로필 설정", isChevronButtonHidden: true)
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return barView
    }()
}

private extension ProfileSettingViewController {
    
    func setUp() {
        setUpLayout()
    }
    
    func setUpLayout() {
        view.backgroundColor = .white
        view.addSubviews(navigationBarView)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
    
    @objc func didTapCancelButton(_ sender: UITapGestureRecognizer) {
        coordinator?.dismiss()
    }
    
}
