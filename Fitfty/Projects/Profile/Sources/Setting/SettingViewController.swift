//
//  SettingViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public final class SettingViewController: UIViewController {
    
    private weak var coordinator: SettingCoordinatorInterface?
    private var viewModel: SettingViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: SettingCoordinatorInterface, viewModel: SettingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SettingViewController {
    
    func setUp() {
        view.backgroundColor = .red
    }
}
