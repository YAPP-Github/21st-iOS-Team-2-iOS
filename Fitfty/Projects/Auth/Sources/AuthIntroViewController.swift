//
//  IntroViewController.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/01/24.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Common

final public class AuthIntroViewController: UIViewController {
    private let coordinator: AuthCoordinatorInterface
    private let contentView = AuthIntroView()

    public override func loadView() {
        self.view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(coordinator: AuthCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
}
