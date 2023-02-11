//
//  AppCoordinator.swift
//  Coordinator
//
//  Created by Watcha-Ethan on 2022/12/03.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

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
        /// - NOTE: Test를 위해 임시로 온보딩뷰를 바로 띄우게끔 해줬어요. 리뷰 승인 후 지울 코드
        let coordinator = makeOnboardingCoordinator()
        coordinator.start()
    }
}

private extension AppCoordinator {
    func makeAuthCoordinator() -> Coordinator {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        return coordinator
    }
    
    func makeOnboardingCoordinator() -> Coordinator {
        let coordinator = OnboardingCoordinator(navigationController: navigationController)
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        return coordinator
    }
    
    func showMainFlow() {
        navigationController.viewControllers.removeAll()
        let tabCoordinator = TabCoordinator.init(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.parentCoordinator = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })

        switch childCoordinator.type {
        case .login, .onboarding:
            childCoordinators.removeAll()
            navigationController.viewControllers.removeAll()

            showMainFlow()
        default:
            break
        }
    }
}
