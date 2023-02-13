//
//  PersonalInfoCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Setting
import Common
import Core

final class PersonalInfoCoordinator: Coordinator {
    
    var type: CoordinatorType { .personalInfo }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makePersonalInfoViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension PersonalInfoCoordinator {
    
    func makePersonalInfoViewController() -> UIViewController {
        let viewController = PersonalInfoViewController(
            coordinator: self,
            viewModel: PersonalInfoViewModel(
                repository: DefaultSettingRepository()
            )
        )
        return viewController
    }
    
}

extension PersonalInfoCoordinator: PersonalInfoCoordinatorInterface {
    
    func finished() {
        navigationController.popViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}
