//
//  ReportCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import UIKit
import Profile
import Common

final class ReportCoordinator: Coordinator {
    
    var type: CoordinatorType { .report }
    var reportType: ReportType
    var reportedToken: String
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(
        navigationController: BaseNavigationController = BaseNavigationController(),
        reportType: ReportType,
        reportedToken: String
    ) {
        self.navigationController = navigationController
        self.reportType = reportType
        self.reportedToken = reportedToken
    }
    
    func start() {
        let viewController = makeReportViewController(reportType: reportType)
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

private extension ReportCoordinator {
    
    func makeReportViewController(reportType: ReportType) -> UIViewController {
        let viewController = ReportViewController(
            coordinator: self,
            reportType: reportType
        )
        return viewController
    }
    
    func makeDetailReportViewController() -> UIViewController {
        let coordinator = DetailReportCoordinator(reportedToken: reportedToken, reportType: reportType)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        let bottomSheetViewController = BottomSheetViewController(
            style: .custom(480),
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }

}

extension ReportCoordinator: ReportCoordinatorInterface {
    
    func showDetailReport(myUserToken: String, otherUserToken: String) {
        print("showDetailReport")
        let viewController = makeDetailReportViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
    func dismiss() {
        bottomSheetDelegate?.dismissBottomSheet { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController.viewControllers.removeAll()
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
}

extension ReportCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
        switch childCoordinator.type {
        case .detailReport:
            navigationController.dismiss(animated: true) {
                childCoordinator.navigationController.viewControllers.removeAll()
            }
        default: break
        }
    }
    
}
