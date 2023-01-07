//
//  UploadCodyCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MainFeed

final class UploadCodyCoordinator: Coordinator {
    var type: CoordinatorType { .uploadCody }
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationConrtoller: UINavigationController = UINavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeUploadCodyViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension UploadCodyCoordinator {
    func makeUploadCodyViewController() -> UIViewController {
        let viewController = UploadCodyViewController(coordinator: self)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}

extension UploadCodyCoordinator: UploadCodyCoordinatorInterface {
    func dismissUploadCody(_ viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
    
    func showAlbum() {
        
    }
}
