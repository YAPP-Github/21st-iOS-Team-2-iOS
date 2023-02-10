//
//  AuthCoordinator.swift
//  Coordinator
//
//  Created by Watcha-Ethan on 2022/12/03.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

import Auth
import Common

final class AuthCoordinator: Coordinator {
    var type: CoordinatorType { .login }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeAuthViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension AuthCoordinator: AuthCoordinatorInterface {
    func pushIntroView() {
        let viewController = makeIntroViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushPermissionView() {
        let viewController = makePermissionViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushMainFeedView() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension AuthCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
}

private extension AuthCoordinator {
    func makeAuthViewController() -> UIViewController {
        let viewController = AuthViewController(
            viewModel: AuthViewModel(),
            coordinator: self
        )
        return viewController
    }
    
    func makeIntroViewController() -> UIViewController {
        let viewController = AuthIntroViewController(
            coordinator: self
        )
        return viewController
    }
    
    func makePermissionViewController() -> UIViewController {
        let viewController = AuthPermissionViewController(
            coordinator: self
        )
        return viewController
    }
}
