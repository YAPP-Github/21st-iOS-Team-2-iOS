//
//  UploadCodyCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MainFeed
import Common

final class UploadCodyCoordinator: Coordinator {
    var type: CoordinatorType { .uploadCody }
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeUploadCodyViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension UploadCodyCoordinator {
    func makeUploadCodyViewController() -> UIViewController {
        let viewController = UploadCodyViewController(coordinator: self)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
    
    func makeAlbumViewController() -> UIViewController {
        let coordinator = AlbumCoordinator()
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
        let bottomSheetViewController = BottomSheetViewController(
            style: .large,
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
}

extension UploadCodyCoordinator: UploadCodyCoordinatorInterface {
    
    func dismiss() {
        navigationController.dismiss(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func showAlbum() {
        let viewController = makeAlbumViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
}

extension UploadCodyCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
    
}
