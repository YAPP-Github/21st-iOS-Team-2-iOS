//
//  UserCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Profile
import Common

final class UserCoordinator: Coordinator {
    
    var type: CoordinatorType { .user }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationConrtoller: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationConrtoller
        navigationConrtoller.setCustomBackButton()

    }
    
    func start() {
        let viewController = makeUserProfileViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension UserCoordinator {
    func makeUserProfileViewController() -> UIViewController {
        let viewController = UserProfileViewController(coordinator: self)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeUserPostViewController() -> UIViewController {
        let viewController = UserPostViewController(coordinator: self)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeReportViewController() -> UIViewController {
        let bottomSheetViewController =
        BottomSheetViewController(
            style: .small,
            contentViewController: ReportViewController(coordinator: self)
        )
        bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
}

extension UserCoordinator: UserProfileCoordinatorInterface {
   
    func showPost() {
        let viewController = makeUserPostViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReport(_ viewController: UIViewController) {
        let reportViewController = makeReportViewController()
        reportViewController.modalPresentationStyle = .overFullScreen
        viewController.present(reportViewController, animated: false)
    }
    
    func dismissReport() {
        navigationController.dismiss(animated: true)
        bottomSheetDelegate?.dismissBottomSheet()
    }
    
    func showProfile() {
        let viewController = makeUserProfileViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
