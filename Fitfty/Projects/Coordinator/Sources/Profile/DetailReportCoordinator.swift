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
import Core

final class DetailReportCoordinator: Coordinator {
    
    var type: CoordinatorType { .detailReport }
    var userToken: String?
    var boardToken: String?
    var reportType: ReportType
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(
        navigationController: BaseNavigationController = BaseNavigationController(),
        reportType: ReportType,
        boardToken: String?,
        userToken: String?
    ) {
        self.navigationController = navigationController
        self.userToken = userToken
        self.boardToken = boardToken
        self.reportType = reportType
    }
    
    func start() {
        let viewController = makeDetailReportViewController()
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

private extension DetailReportCoordinator {
    
    func makeDetailReportViewController() -> UIViewController {
        let viewController = DetailReportViewController(
            coordinator: self,
            viewModel: DetailReportViewModel(
                userManager: DefaultUserManager.shared,
                userToken: userToken,
                boardToken: boardToken,
                reportType: reportType,
                fitftyRepository: DefaultFitftyRepository()
            )
        )
        return viewController
    }
    
}

extension DetailReportCoordinator: DetailReportCoordinatorInterface {
    
    func dismiss() {
        bottomSheetDelegate?.dismissBottomSheet { 
            self.navigationController.viewControllers.removeAll()
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
    
}
