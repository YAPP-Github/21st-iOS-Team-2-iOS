//
//  ProfileCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2022/12/13.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation
import UIKit
import Profile
import Common

final class ProfileCoordinator: Coordinator {
    
    var type: CoordinatorType { .profile }
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeProfileViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension ProfileCoordinator {
    func makeProfileViewController() -> UIViewController {
        let viewController = MyProfileViewController(coordinator: self)
        return viewController
    }
}

extension ProfileCoordinator: MyProfileCoordinatorInterface {
    func showPost() {
        let postViewController = MyPostViewController(coordinator: self)
        postViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(postViewController, animated: true)
    }
}
