//
//  ProfileSettingCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Profile

final class ProfileSettingCoordinator: Coordinator {
    
    var type: CoordinatorType { .profileSetting }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeProfileSettingViewController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension ProfileSettingCoordinator {
    
    func makeProfileSettingViewController() -> UIViewController {
        let viewController = ProfileSettingViewController(coordinator: self, viewModel: ProfileSettingViewModel())
        return viewController
    }
    
}

extension ProfileSettingCoordinator: ProfileSettingCoordinatorInterface {
    
    func dismiss() {
        navigationController.viewControllers.removeAll()
        bottomSheetDelegate?.dismissBottomSheet()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
