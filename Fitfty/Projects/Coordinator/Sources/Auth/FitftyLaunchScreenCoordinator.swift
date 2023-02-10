//
//  FitftyLaunchScreenCoordinator.swift
//  Coordinator
//
//  Created by Watcha-Ethan on 2023/02/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Auth
import Common

final class FitftyLaunchScreenCoordinator: Coordinator {
    var type: CoordinatorType { .launchScreen }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeFitftyLaunchScreenViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension FitftyLaunchScreenCoordinator: FitftyLaunchScreenCoordinatorInterface {
    func pushAuthView() {
        let coordinator = makeAuthCoordinator()
        coordinator.start()
    }
    
    func pushMainFeedView() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension FitftyLaunchScreenCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

private extension FitftyLaunchScreenCoordinator {
    func makeFitftyLaunchScreenViewController() -> UIViewController {
        let viewController = FitftyLaunchScreenViewController(
            viewModel: FitftyLaunchScreenViewModel(),
            coordinator: self
        )
        return viewController
    }
    
    func makeAuthCoordinator() -> Coordinator {
        navigationController.viewControllers.removeAll()
        let coordinator = AuthCoordinator(navigationController: navigationController)
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        return coordinator
    }
}
