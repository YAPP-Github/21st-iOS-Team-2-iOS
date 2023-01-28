//
//  SettingCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Profile
import Common

final class SettingCoordinator: Coordinator {
    
    var type: CoordinatorType { .address }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationConrtoller: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeSettingViewController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension SettingCoordinator {
    
    func makeSettingViewController() -> UIViewController {
        let viewController = SettingViewController(coordinator: self, viewModel: SettingViewModel())
        return viewController
    }
}

extension SettingCoordinator: SettingCoordinatorInterface {
    
    func showProfileSetting() {
        print(#function)
    }
    
    func showFeedSetting() {
        print(#function)
    }
    
    func showMyInfoSetting() {
        print(#function)
    }
    
    func finished() {
        navigationController.popViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension SettingCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
}
