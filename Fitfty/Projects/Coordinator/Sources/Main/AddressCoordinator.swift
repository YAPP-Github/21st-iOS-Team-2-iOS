//
//  AddressCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MainFeed
import Common

final class AddressCoordinator: Coordinator {
    
    var type: CoordinatorType { .address }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeAddressViewController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension AddressCoordinator {
    
    func makeAddressViewController() -> UIViewController {
        let viewController = AddressViewController(coordinator: self, viewModel: AddressViewModel())
        return viewController
    }
    
}

extension AddressCoordinator: AddressCoordinatorInterface {
    
    func dismiss() {
        navigationController.viewControllers.removeAll()
        bottomSheetDelegate?.dismissBottomSheet()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
