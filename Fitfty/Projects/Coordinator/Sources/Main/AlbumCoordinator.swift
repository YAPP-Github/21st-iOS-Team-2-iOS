//
//  AlbumCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MainFeed

final class AlbumCoordinator: Coordinator {
    
    var type: CoordinatorType { .album }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationConrtoller: UINavigationController = UINavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeAlbumViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension AlbumCoordinator {
    func makeAlbumViewController() -> UIViewController {
        let viewController = AlbumViewController()
        return viewController
    }
}