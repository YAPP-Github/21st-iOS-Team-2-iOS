//
//  UserCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Profile

final class UserCoordinator: Coordinator {
 
    var type: CoordinatorType { .user }
    weak var finishDelegate: CoordinatorFinishDelegate?
   
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationConrtoller: UINavigationController = UINavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeUserViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension UserCoordinator {
    func makeUserViewController() -> UIViewController {
        let viewController = UserProfileViewController(coordinator: self)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}

extension UserCoordinator: UserProfileCoordinatorInterface {
    func dismiss() {
        navigationController.popViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
