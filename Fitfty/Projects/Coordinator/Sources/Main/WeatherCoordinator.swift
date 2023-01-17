//
//  WeatherCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MainFeed

final class WeatherCoordinator: Coordinator {
    
    var type: CoordinatorType { .weather }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationConrtoller: UINavigationController = UINavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeWeatherViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension WeatherCoordinator {
    
    func makeWeatherViewController() -> UIViewController {
        let viewController = WeatherViewController(coordinator: self, viewModel: WeatherViewModel())
        return viewController
    }
    
}

extension WeatherCoordinator: WeatherCoordinatorInterface {
    
    func showSettingAddress() {
        print(#function)
    }
    
    func finished() {
        navigationController.popViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
