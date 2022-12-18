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

final class ProfileCoordinator: Coordinator {
    
    var type: CoordinatorType { .profile }
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationConrtoller: UINavigationController = UINavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeProfileViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension ProfileCoordinator {
    func makeProfileViewController() -> UIViewController {
        let viewController = ProfileViewController(coordinator: self)
        return viewController
    }
}

extension ProfileCoordinator: ProfileCoordinatorInterface {
    func showPost() {
        let postViewController = PostViewController(coordinator: self)
        navigationController.pushViewController(postViewController, animated: true)
    }
}
