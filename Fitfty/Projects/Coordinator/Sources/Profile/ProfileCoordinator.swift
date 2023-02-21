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
    var nickname: String?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    init(
        navigationController: BaseNavigationController = BaseNavigationController(),
        profileType: ProfileType,
        presentType: ProfilePresentType,
        nickname: String?
    ) {
        self.navigationController = navigationController
        self.profileType = profileType
        self.presentType = presentType
        self.nickname = nickname
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
            presentType: presentType,
            viewModel: ProfileViewModel(),
            nickname: nickname
        )
        return viewController
    }
    
    func makePostCoordinator(profileType: ProfileType, boardToken: String) -> PostCoordinator {
        let coordinator = PostCoordinator(
            navigationController: navigationController,
            profileType: profileType,
            presentType: presentType,
            boardToken: boardToken
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
    
    func makeMyFitftyCoordinator(_ myFitftyType: MyFitftyType) -> MyFitftyCoordinator {
        let coordinator = MyFitftyCoordinator(myFitftyType: myFitftyType, boardToken: nil)
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
    
    func makeReportViewController(reportedToken: String) -> UIViewController {
        let coordinator = ReportCoordinator(reportPresentType: .userReport, boardToken: nil, userToken: reportedToken)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        let bottomSheetViewController =
        BottomSheetViewController(
            style: .small,
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
    
}

extension ProfileCoordinator: ProfileCoordinatorInterface {
    
    func showPost(profileType: ProfileType, boardToken: String) {
        let coordinator = makePostCoordinator(profileType: profileType, boardToken: boardToken)
        coordinator.start()
    }
    
    func showReport(reportedToken: String) {
        let viewController = makeReportViewController(reportedToken: reportedToken)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
    
    func showMyFitfty(_ myFitftyType: MyFitftyType) {
        let coordinator = makeMyFitftyCoordinator(myFitftyType)
        coordinator.start()
        coordinator.navigationController.modalPresentationStyle = .fullScreen
        navigationController.present(coordinator.navigationController, animated: true)
    }
    
    func showSetting() {
        let coordinator = makeSettingCoordinator()
        coordinator.start()
    }
    
    func switchMainTab() {
        guard let tabCoordinator = parentCoordinator as? TabCoordinator else {
            return
        }
        tabCoordinator.setSelectedIndex(0)
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
        switch childCoordinator.type {
        case .myFitfty, .report:
            navigationController.dismiss(animated: true) {
                childCoordinator.navigationController.viewControllers.removeAll()
            }
        default: break
        }
    }
    
}
