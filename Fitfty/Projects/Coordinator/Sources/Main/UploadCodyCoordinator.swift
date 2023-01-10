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
    var navigationController: UINavigationController
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationConrtoller: UINavigationController = UINavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeUploadCodyViewController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: FitftyFont.appleSDBold(size: 24).font ?? UIFont.systemFont(ofSize: 24)]
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension UploadCodyCoordinator {
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
