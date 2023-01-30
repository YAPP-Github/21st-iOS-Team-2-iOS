//
//  MainCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import MainFeed
import Common
import Profile

final class MainCoordinator: Coordinator {
    
    var type: CoordinatorType { .main }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
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
    
    func makeAddressViewController() -> UIViewController {
        let coordinator = AddressCoordinator()
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        let bottomSheetViewController = BottomSheetViewController(
            style: .large,
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
    
    func makePostCoordinator() -> PostCoordinator {
        let coordinator = PostCoordinator(navigationConrtoller: navigationController)
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
    
    func makeProfileCoordinator() -> ProfileCoordinator {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
   
    func makeWeatherCoordinator() -> WeatherCoordinator {
        let coordinator = WeatherCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
    
    func makeWelcomeViewController() -> UIViewController {
        let coordinator = WelcomeCoordinator()
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        let bottomSheetViewController = BottomSheetViewController(
            style: .custom(420),
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
    
}

extension MainCoordinator: MainCoordinatorInterface {
    
    public func showSettingAddress() {
        let viewController = makeAddressViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
    public func showPost(profileType: ProfileType) {
        let coordinator = makePostCoordinator()
        coordinator.profileType = profileType
        coordinator.start()
    }
    
    public func showProfile(profileType: ProfileType) {
        let coordinator = makeProfileCoordinator()
        coordinator.profileType = profileType
        coordinator.navigationController.setCustomBackButton()
        coordinator.showMainProfile()
    }
    
    public func showWeatherInfo() {
        let coordinator = makeWeatherCoordinator()
        coordinator.start()
    }
    
    public func showWelcomeSheet() {
        let viewController = makeWelcomeViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
}

extension MainCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
}
