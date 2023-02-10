//
//  PermissionViewController.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/01/25.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final public class AuthPermissionViewController: UIViewController {
    private let coordinator: IntroCoordinatorInterface
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(coordinator: IntroCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
}
