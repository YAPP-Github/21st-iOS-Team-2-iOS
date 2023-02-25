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
import Core

final class MyFitftyCoordinator: Coordinator {
    var type: CoordinatorType { .myFitfty }
    var myFitftyType: MyFitftyType
    var boardToken: String?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(
        navigationController: BaseNavigationController = BaseNavigationController(),
        myFitftyType: MyFitftyType,
        boardToken: String?
    ) {
        self.navigationController = navigationController
        self.myFitftyType = myFitftyType
        self.boardToken = boardToken
    }
    
    func start() {
        let viewController = makeMyFitftyViewController(boardToken: boardToken)
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension MyFitftyCoordinator {
    func makeMyFitftyViewController(boardToken: String?) -> UIViewController {
        let viewController = MyFitftyViewController(
            coordinator: self,
            myFitftyType: myFitftyType,
            viewModel: MyFitftyViewModel(
                weatherRepository: DefaultWeatherRepository(),
                addressRepository: DefaultAddressRepository(),
                userManager: DefaultUserManager.shared,
                myFitftyType: myFitftyType,
                boardToken: boardToken
            )
        )
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
