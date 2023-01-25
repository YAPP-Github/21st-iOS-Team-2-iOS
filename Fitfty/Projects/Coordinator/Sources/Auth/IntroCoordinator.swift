//
//  IntroCoordinator.swift
//  Coordinator
//
//  Created by Watcha-Ethan on 2023/01/25.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Auth
import Common

final class IntroCoordinator: Coordinator {
    var type: CoordinatorType { .login }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationConrtoller: BaseNavigationController) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeIntroViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension IntroCoordinator {
    func makeIntroViewController() -> UIViewController {
        let viewController = IntroViewController(
            coordinator: self
        )
        
        return viewController
    }
    
    func makePermissionViewController() -> UIViewController {
        let viewController = PermissionViewController(
            coordinator: self
        )
        
        return viewController
    }
}

extension IntroCoordinator: IntroCoordinatorInterface {
    func pushPermissionView() {
        let viewController = makePermissionViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
