//
//  ProfileSettingViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

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
    
}

private extension ProfileSettingViewController {
    
    func setUp() {
        view.backgroundColor = .red
    }
}
