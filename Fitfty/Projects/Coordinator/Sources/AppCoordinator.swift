//
//  AppCoordinator.swift
//  Coordinator
//
//  Created by Watcha-Ethan on 2022/12/03.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

final public class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    public init(navigationConrtoller: UINavigationController) {
        self.navigationController = navigationConrtoller
    }
    
    public func start() {
        let coordinator = makeAuthCoordinator()
        coordinator.start()
    }
}

private extension AppCoordinator {
    func makeAuthCoordinator() -> Coordinator {
        let coordinator = AuthCoordinator(navigationConrtoller: navigationController)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        return coordinator
    }
}
