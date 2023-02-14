//
//  DetailReportCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/01/31.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import UIKit
import Profile
import Common

final class DetailReportCoordinator: Coordinator {
    
    var type: CoordinatorType { .detailReport }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeDetailReportViewController()
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

private extension DetailReportCoordinator {
    
    func makeDetailReportViewController() -> UIViewController {
        let viewController = DetailReportViewController(coordinator: self)
        return viewController
    }
    
}

extension DetailReportCoordinator: DetailReportCoordinatorInterface {
    
    func dismiss() {
        bottomSheetDelegate?.dismissBottomSheet { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController.dismiss(animated: false)
            self.parentCoordinator?.navigationController.viewControllers.removeAll()
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
}
