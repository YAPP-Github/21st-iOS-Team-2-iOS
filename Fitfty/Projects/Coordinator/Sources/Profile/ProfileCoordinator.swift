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
    var profileType: ProfileType
    var presentType: ProfilePresentType
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    init(
        navigationController: BaseNavigationController = BaseNavigationController(),
        profileType: ProfileType,
        presentType: ProfilePresentType
    ) {
        self.navigationController = navigationController
        self.profileType = profileType
        self.presentType = presentType
    }
    
    func start() {
        let viewController = makeProfileViewController()
        if presentType == .mainProfile {
            viewController.hidesBottomBarWhenPushed = true
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension ProfileCoordinator {
    
    func makeProfileViewController() -> UIViewController {
        let viewController = ProfileViewController(
            coordinator: self,
            profileType: profileType,
            presentType: presentType
        )
        return viewController
    }
    
    func makePostCoordinator(profileType: ProfileType) -> PostCoordinator {
        let coordinator = PostCoordinator(
            navigationController: navigationController,
            profileType: profileType,
            presentType: presentType
        )
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
    
    func makeMyFitftyCoordinator() -> MyFitftyCoordinator {
        let coordinator = MyFitftyCoordinator(myFitftyType: .modifyMyFitfty)
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
    
    func makeDetailReportViewController() -> UIViewController {
        let coordinator = DetailReportCoordinator()
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

extension ProfileCoordinator: ProfileCoordinatorInterface {
    
    func showPost(profileType: ProfileType) {
        let coordinator = makePostCoordinator(profileType: profileType)
        coordinator.start()
    }
    
    func showReport() {
        let bottomSheetViewController = makeReportViewController()
        bottomSheetViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(bottomSheetViewController, animated: false)
    }
    
    func showModifyMyFitfty() {
        let coordinator = makeMyFitftyCoordinator()
        coordinator.start()
        coordinator.navigationController.modalPresentationStyle = .overFullScreen
        navigationController.present(coordinator.navigationController, animated: true)
    }
    
    func showDetailReport() {
        navigationController.dismiss(animated: false)
        let viewController = makeDetailReportViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
    func showSetting() {
        let coordinator = makeSettingCoordinator()
        coordinator.start()
    }
    
    func dismiss() {
        bottomSheetDelegate?.dismissBottomSheet { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController.dismiss(animated: false)
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
    
    func finished() {
        navigationController.popViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func finishedTapGesture() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

extension ProfileCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
    
}
