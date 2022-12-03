//
//  AuthCoordinator.swift
//  Coordinator
//
//  Created by Watcha-Ethan on 2022/12/03.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Auth

final public class AuthCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    public init(navigationConrtoller: UINavigationController) {
        self.navigationController = navigationConrtoller
    }
    
    public func start() {
        let viewController = makeAuthViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension AuthCoordinator {
    private func makeAuthViewController() -> UIViewController {
        let viewController = AuthViewController()
        viewController.coordinator = self
        return viewController
    }
}

extension AuthCoordinator: AuthCoordinatorInterface {
    public func showMainFeedView() {
        
    }
    
    public func showOnboardingView() {
        
    }
}
