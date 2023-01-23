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
    
    init(navigationConrtoller: BaseNavigationController) {
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
        let viewController = AuthViewController(
            viewModel: AuthViewModel(),
            coordinator: self
        )
        viewController.coordinator = self
        return viewController
    }
}

extension AuthCoordinator: AuthCoordinatorInterface {
    
    func presentKakaoLoginView() {
        
    }
    
    func pushMainFeedView() {
        
    }
    
    func pushOnboardingView() {
        
    }
}
