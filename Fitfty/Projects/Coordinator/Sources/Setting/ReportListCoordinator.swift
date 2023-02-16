//
//  ReportListCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import UIKit
import Common
import Setting

final class ReportListCoordinator: Coordinator {
    
    var type: CoordinatorType { .reportList }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeReportListViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension ReportListCoordinator {
    
    func makeReportListViewController() -> UIViewController {
        let viewController = ReportListViewController(coordinator: self)
        return viewController
    }
    
}

extension ReportListCoordinator: ReportListCoordinatorInterface {
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
    
}
