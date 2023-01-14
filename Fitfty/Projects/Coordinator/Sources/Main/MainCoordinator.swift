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
    
    func makeWeatherCoordinator() -> WeatherCoordinator {
        let coordinator = WeatherCoordinator(navigationConrtoller: navigationController)
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        return coordinator
    }
    
}

extension MainCoordinator: MainCoordinatorInterface {
    
    public func showSettingAddress() {
        let viewController = makeAddressViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
    public func showWeatherInfo() {
        let coordinator = makeWeatherCoordinator()
        coordinator.start()
    }
    
}

extension MainCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
}

extension MainCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
}
