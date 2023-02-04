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

final class MyFitftyCoordinator: Coordinator {
    var type: CoordinatorType { .myFitfty }
    var myFitftyType: MyFitftyType
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationController: BaseNavigationController = BaseNavigationController(), myFitftyType: MyFitftyType) {
        self.navigationController = navigationController
        self.myFitftyType = myFitftyType
    }
    
    func start() {
        let viewController = makeMyFitftyViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension MyFitftyCoordinator {
    func makeMyFitftyViewController() -> UIViewController {
        let viewController = MyFitftyViewController(coordinator: self, myFitftyType: myFitftyType)
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

extension MyFitftyCoordinator: MyFitftyCoordinatorInterface {
    
    func dismiss() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func showAlbum() {
        let viewController = makeAlbumViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
}

extension MyFitftyCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
    
}
