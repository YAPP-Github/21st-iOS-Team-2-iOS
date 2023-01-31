//
//  ProfileCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2022/12/13.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation
import UIKit
import Profile
import Common

final class ProfileCoordinator: Coordinator {
    
    var type: CoordinatorType { .profile }
    var profileType: ProfileType?
    var presentType: PresentType?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeProfileViewController()
        if presentType == .main {
            viewController.hidesBottomBarWhenPushed = true
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension ProfileCoordinator {
    
    func makeProfileViewController() -> UIViewController {
        if let profileType = profileType,
           let presentType = presentType {
            let viewController = ProfileViewController(
                coordinator: self,
                profileType: profileType,
                presentType: presentType
            )
            return viewController
        }
        return UIViewController()
    }
    
    func makePostCoordinator(profileType: ProfileType) -> PostCoordinator {
        let coordinator = PostCoordinator(navigationConrtoller: navigationController)
        coordinator.profileType = profileType
        coordinator.presentType = presentType
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
    
    func makeSettingCoordinator() -> SettingCoordinator {
        let coordinator = SettingCoordinator(navigationConrtoller: navigationController)
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
    
    func makeUploadCodyCoordinator() -> UploadCodyCoordinator {
        let coordinator = UploadCodyCoordinator()
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
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

extension ProfileCoordinator: ProfileCoordinatorInterface {
    
    func showPost(profileType: Profile.ProfileType) {
        let coordinator = makePostCoordinator(profileType: profileType)
        coordinator.start()
    }
    
    func showBottomSheet() {
        let bottomSheetViewController = makeReportViewController()
        bottomSheetViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(bottomSheetViewController, animated: false)
    }
    
    func showUploadCody() {
        let coordinator = makeUploadCodyCoordinator()
        coordinator.start()
        coordinator.navigationController.modalPresentationStyle = .overFullScreen
        navigationController.present(coordinator.navigationController, animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: false)
        bottomSheetDelegate?.dismissBottomSheet()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

extension ProfileCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
    
    func showSetting() {
        let coordinator = makeSettingCoordinator()
        coordinator.start()
    }
    
}
