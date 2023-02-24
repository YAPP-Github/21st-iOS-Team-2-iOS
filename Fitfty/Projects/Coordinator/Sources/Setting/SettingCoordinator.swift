//
//  SettingCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import WebKit

import Setting
import Common

final class SettingCoordinator: Coordinator {
    
    var type: CoordinatorType { .setting }
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
    
    func makeProfileSettingViewController() -> UIViewController {
        let coordinator = ProfileSettingCoordinator()
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        let bottomSheetViewController = BottomSheetViewController(
            style: .custom(UIScreen.main.bounds.height - 70),
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
    
    func makeFeedSettingViewController() -> UIViewController {
        let coordinator = FeedSettingCoordinator()
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        let bottomSheetViewController = BottomSheetViewController(
            style: .custom(450),
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
    
    func makeMyInfoCoordinator() -> Coordinator {
        let coordinator = PersonalInfoCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
}

extension SettingCoordinator: SettingCoordinatorInterface {
    
    func showProfileSetting() {
        let viewController = makeProfileSettingViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
    func showFeedSetting() {
        let viewController = makeFeedSettingViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
    func showMyInfoSetting() {
        let coordinator = makeMyInfoCoordinator()
        coordinator.start()
    }
    
    func showTermsOfUse() {
        let webViewController = FitftyWebViewController(url: "https://maze-mozzarella-6e5.notion.site/dd559e6017ee499fa569148b8621966d")
        navigationController.present(webViewController, animated: true)
    }
    
    func showPrivacyRule() {
        let webViewController = FitftyWebViewController(url: "https://maze-mozzarella-6e5.notion.site/ed1e98c3fee5417b89f85543f4a398d2")
        navigationController.present(webViewController, animated: true)
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
