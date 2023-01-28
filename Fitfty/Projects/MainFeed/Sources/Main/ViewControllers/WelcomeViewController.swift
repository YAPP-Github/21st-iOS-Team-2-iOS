//
//  WelcomeViewController.swift
//  MainFeed
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public class WelcomeViewController: UIViewController {

    private weak var coordinator: WelcomeCoordinatorInterface?
    private var viewModel: WelcomeViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: WelcomeCoordinatorInterface, viewModel: WelcomeViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator?.dismiss()
    }
}

private extension WelcomeViewController {
    
    func setUp() {
        view.backgroundColor = .red
    }
}
