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
import Core

final class ReportCoordinator: Coordinator {
    
    var type: CoordinatorType { .report }
    var reportPresentType: ReportPresentType
    var userToken: String?
    var boardToken: String?
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(
        navigationController: BaseNavigationController = BaseNavigationController(),
        reportPresentType: ReportPresentType,
        boardToken: String?,
        userToken: String?
    ) {
        self.navigationController = navigationController
        self.reportPresentType = reportPresentType
        self.userToken = userToken
        self.boardToken = boardToken
    }
    
    func start() {
        let viewController = makeReportViewController(
            reportPresentType: reportPresentType,
            userToken: userToken,
            boardToken: boardToken
        )
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

private extension ReportCoordinator {
    
    func makeReportViewController(reportPresentType: ReportPresentType, userToken: String?, boardToken: String?) -> UIViewController {
        let viewController = ReportViewController(
            coordinator: self,
            viewModel: ReportViewModel(
                userManager: DefaultUserManager.shared,
                userToken: userToken,
                boardToken: boardToken,
                fitftyRepository: DefaultFitftyRepository()
            ),
            reportPresentType: reportPresentType,
            userToken: userToken,
            boardToken: boardToken
        )
        return viewController
    }
    
    func makeDetailReportViewController(reportType: ReportType, userToken: String?, boardToken: String?) -> UIViewController {
        let coordinator = DetailReportCoordinator(reportType: reportType, boardToken: boardToken, userToken: userToken)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        let bottomSheetViewController = BottomSheetViewController(
            style: .custom(511),
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }

}

extension ReportCoordinator: ReportCoordinatorInterface {
    
    func showDetailReport(_ reportType: ReportType, userToken: String?, boardToken: String?) {
        let viewController = makeDetailReportViewController(reportType: reportType, userToken: userToken, boardToken: boardToken)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
    func dismiss() {
        bottomSheetDelegate?.dismissBottomSheet { 
            self.navigationController.viewControllers.removeAll()
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
    
    func popToRoot() {
        bottomSheetDelegate?.dismissBottomSheet {
            self.navigationController.viewControllers.removeAll()
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
            self.parentCoordinator?.navigationController.popToRootViewController(animated: true)
        }
    }
    
}

extension ReportCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
        switch childCoordinator.type {
        case .detailReport:
            bottomSheetDelegate?.dismissBottomSheet { 
                self.navigationController.viewControllers.removeAll()
                self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
            }
        default: break
        }
    }
    
}
