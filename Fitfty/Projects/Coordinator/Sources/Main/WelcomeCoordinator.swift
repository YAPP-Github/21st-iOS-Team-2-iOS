//
//  WelcomeCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MainFeed
import Common
import Core

final class WelcomeCoordinator: Coordinator {
    
    var type: CoordinatorType { .welcome }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeAddressViewController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension WelcomeCoordinator {
    
    func makeAddressViewController() -> UIViewController {
        let viewController = WelcomeViewController(
            coordinator: self, viewModel: WelcomeViewModel(
                fitftyRepository: DefaultFitftyRepository(),
                userManager: DefaultUserManager.shared
            )
        )
        return viewController
    }
    
}

extension WelcomeCoordinator: WelcomeCoordinatorInterface {
    
    func dismiss() {
        bottomSheetDelegate?.dismissBottomSheet {
            self.navigationController.viewControllers.removeAll()
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
}
