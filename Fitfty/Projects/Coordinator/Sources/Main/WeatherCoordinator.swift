//
//  WeatherCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MainFeed
import Common
import Core

final class WeatherCoordinator: Coordinator {
    
    var type: CoordinatorType { .weather }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeWeatherViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension WeatherCoordinator {
    
    func makeWeatherViewController() -> UIViewController {
        let viewController = WeatherViewController(
            coordinator: self,
            viewModel: WeatherViewModel(
                addressRepository: DefaultAddressRepository(),
                weatherRepository: DefaultWeatherRepository(),
                userManager: DefaultUserManager.shared
            )
        )
        return viewController
    }
    
    func makeAddressViewController() -> UIViewController {
        let coordinator = AddressCoordinator()
        childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        let bottomSheetViewController = BottomSheetViewController(
            style: .large,
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
    
}

extension WeatherCoordinator: WeatherCoordinatorInterface {
    
    func showSettingAddress() {
        let viewController = makeAddressViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
    func finished() {
        navigationController.popViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension WeatherCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
}
