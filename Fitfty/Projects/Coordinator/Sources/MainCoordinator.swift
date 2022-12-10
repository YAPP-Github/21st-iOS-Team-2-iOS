//
//  MainCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import MainFeed

final class MainCoordinator: Coordinator {
    var type: CoordinatorType { .main }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationConrtoller: UINavigationController = UINavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeMainViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension MainCoordinator {
    func makeMainViewController() -> UIViewController {
        let viewController = MainViewController(coordinator: self)
        return viewController
    }
}

extension MainCoordinator: MainCoordinatorInterface {
    
    public func showSettingAddress() {
        
    }
}
