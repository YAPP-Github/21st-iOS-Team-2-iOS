//
//  ReportListCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Setting
import Core

final class ReportListCoordinator: Coordinator {
    
    var type: CoordinatorType { .reportList }
    var reportType: ReportType
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(
        navigationController: BaseNavigationController = BaseNavigationController(),
        reportType: ReportType
    ) {
        self.navigationController = navigationController
        self.reportType = reportType
    }
    
    func start() {
        let viewController = makeReportListViewController(reportType: reportType)
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension ReportListCoordinator {
    
    func makeReportListViewController(reportType: ReportType) -> UIViewController {
        let viewController = ReportListViewController(
            coordinator: self,
            viewModel: ReportListViewModel(reportType: reportType, fitftyRepository: DefaultFitftyRepository()),
            reportType: reportType
        )
        return viewController
    }
    
}

extension ReportListCoordinator: ReportListCoordinatorInterface {
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
    
}
