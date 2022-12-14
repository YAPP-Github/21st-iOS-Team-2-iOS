//
//  AddressCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MainFeed

final class AddressCoordinator: Coordinator {
    
    var type: CoordinatorType { .address }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationConrtoller: UINavigationController = UINavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeAddressViewController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension AddressCoordinator {
    
    func makeAddressViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemGreen
        viewController.navigationItem.title = "주소를 변경해볼까요?"
        return viewController
    }
    
}
