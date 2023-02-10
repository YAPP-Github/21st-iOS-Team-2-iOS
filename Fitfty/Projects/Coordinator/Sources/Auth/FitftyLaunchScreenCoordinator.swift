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

protocol FitftyLaunchScreenCoordinatorDelegate: AnyObject {
    func pushAuthView()
    func pushMainFeedView()
}

final class FitftyLaunchScreenCoordinator: Coordinator {
    var type: CoordinatorType { .launchScreen }
    var finishDelegate: CoordinatorFinishDelegate?
    var launchScreenDelegate: FitftyLaunchScreenCoordinatorDelegate?
    
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
        launchScreenDelegate?.pushAuthView()
    }
    
    func pushMainFeedView() {
        launchScreenDelegate?.pushMainFeedView()
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
}
