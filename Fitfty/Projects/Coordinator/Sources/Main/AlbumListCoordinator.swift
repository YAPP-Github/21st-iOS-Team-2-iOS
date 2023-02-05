//
//  AlbumListCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/02/05.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import MainFeed

final class AlbumListCoordinator: Coordinator {
    
    var type: CoordinatorType { .albumList }
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeAlbumListViewController()
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
}

private extension AlbumListCoordinator {
    func makeAlbumListViewController() -> UIViewController {
        let viewController = AlbumListViewController(coordinator: self)
        return viewController
    }
}

extension AlbumListCoordinator: AlbumListCoordinatorInterface {
    
    func dismiss() {
        
    }
    
}
