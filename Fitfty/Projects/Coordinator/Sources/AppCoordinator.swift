//
//  AppCoordinator.swift
//  Coordinator
//
//  Created by Watcha-Ethan on 2022/12/03.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

import Common
import Core

final public class AppCoordinator: Coordinator {
    var type: CoordinatorType { .app }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    public init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let coordinator = makeFitftyLaunchScreenCoordinator()
        coordinator.start()
    }
    
    func showAuthFlow() {
        let coordinator = makeAuthCoordinator()
        coordinator.start()
    }
    
    func showMainFlow() {
        let coordinator = makeTabBarCoordinator()
        coordinator.start()
    }
}

private extension AppCoordinator {
    func makeFitftyLaunchScreenCoordinator() -> Coordinator {
        let coordinator = FitftyLaunchScreenCoordinator(navigationController: navigationController)
        coordinator.finishDelegate = self
        coordinator.launchScreenDelegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        return coordinator
    }
    
    func makeAuthCoordinator() -> Coordinator {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        return coordinator
    }
    
    func makeTabBarCoordinator() -> Coordinator {
        let tabCoordinator = TabCoordinator.init(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.parentCoordinator = self
        childCoordinators.append(tabCoordinator)
        
        return tabCoordinator
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .login:
            childCoordinators.removeAll()
            navigationController.viewControllers.removeAll()

            showMainFlow()
        case .onboarding:
            childCoordinators.removeAll()
            navigationController.viewControllers.removeAll()
            
            showMainFlow()
        default:
            break
        }
    }
}

extension AppCoordinator: FitftyLaunchScreenCoordinatorDelegate {
    func pushAuthView() {
        childCoordinators.removeAll()
        navigationController.viewControllers.removeAll()
        
        showAuthFlow()
    }
    
    func pushMainFeedView() {
        childCoordinators.removeAll()
        navigationController.viewControllers.removeAll()

        showMainFlow()
    }
}
