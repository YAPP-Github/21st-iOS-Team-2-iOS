//
//  UserViewController.swift
//  Profile
//
//  Created by 임영선 on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final public class UserViewController: UIViewController {

    let coordinator: UserCoordinatorInterface
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init(coordinator: UserCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
