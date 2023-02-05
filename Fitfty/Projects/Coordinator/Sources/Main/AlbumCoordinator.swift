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
    
    func makeAlbumListCoordinator() -> AlbumListCoordinator {
        let coordinator = AlbumListCoordinator()
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
}

extension AlbumCoordinator: AlbumCoordinatorInterface {
    
    func dismiss() {
        bottomSheetDelegate?.dismissBottomSheet { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController.viewControllers.removeAll()
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
    
    func showAlbumList() {
        let coordinator = makeAlbumListCoordinator()
        coordinator.start()
        coordinator.navigationController.modalPresentationStyle = .fullScreen
        navigationController.present(coordinator.navigationController, animated: true)
    }
}

extension AlbumCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
    
}
