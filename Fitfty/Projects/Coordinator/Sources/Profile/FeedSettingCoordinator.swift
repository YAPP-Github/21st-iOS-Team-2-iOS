//
//  FeedSettingCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Profile

final class FeedSettingCoordinator: Coordinator {
    
    var type: CoordinatorType { .feedSetting }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeFeedSettingViewController()
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

private extension FeedSettingCoordinator {
    
    func makeFeedSettingViewController() -> UIViewController {
        let viewController = FeedSettingViewController(coordinator: self, viewModel: FeedSettingViewModel())
        return viewController
    }
    
}

extension FeedSettingCoordinator: FeedSettingCoordinatorInterface {
    
    func dismiss() {
        navigationController.viewControllers.removeAll()
        bottomSheetDelegate?.dismissBottomSheet()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}
