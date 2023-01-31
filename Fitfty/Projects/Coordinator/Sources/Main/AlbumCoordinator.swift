//
//  AlbumCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MainFeed
import Common

final class AlbumCoordinator: Coordinator {
    
    var type: CoordinatorType { .album }
    var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeAlbumViewController()
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

private extension AlbumCoordinator {
    func makeAlbumViewController() -> UIViewController {
        let viewController = AlbumViewController(coordinator: self)
        return viewController
    }
}

extension AlbumCoordinator: AlbumCoordinatorInterface {
    
    func dismiss() {
        navigationController.viewControllers.removeAll()
        bottomSheetDelegate?.dismissBottomSheet()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
