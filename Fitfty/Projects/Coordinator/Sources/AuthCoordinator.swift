//
//  AuthCoordinator.swift
//  Coordinator
//
//  Created by Watcha-Ethan on 2022/12/03.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Auth

final class AuthCoordinator: Coordinator {
    var type: CoordinatorType { .login }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationConrtoller: UINavigationController) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeAuthViewController()
        navigationController.pushViewController(viewController, animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

private extension AuthCoordinator {
    func makeAuthViewController() -> UIViewController {
        let viewController = AuthViewController()
        viewController.coordinator = self
        return viewController
    }
}

extension AuthCoordinator: AuthCoordinatorInterface {
    
    public func showOnboardingView() {
        
    }
}
