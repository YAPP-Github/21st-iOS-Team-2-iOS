//
//  PostCoordinator.swift
//  Coordinator
//
//  Created by 임영선 on 2023/01/30.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Profile
import Common

final class PostCoordinator: Coordinator {
    
    var type: CoordinatorType { .post }
    var profileType: ProfileType
    var presentType: ProfilePresentType
    var boardToken: String
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(
        navigationController: BaseNavigationController = BaseNavigationController(),
        profileType: ProfileType,
        presentType: ProfilePresentType,
        boardToken: String
    ) {
        self.navigationController = navigationController
        self.profileType = profileType
        self.presentType = presentType
        self.boardToken = boardToken
    }
    
    func start() {
        let viewController = makePostViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension PostCoordinator {
   
    func makePostViewController() -> UIViewController {
        let viewController = PostViewController(
            coordinator: self,
            profileType: profileType,
            presentType: presentType,
            viewModel: PostViewModel(),
            boardToken: boardToken
        )
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makePostBottomSheetViewController(boardToken: String, filepath: String) -> UIViewController {
        let viewController = MyPostBottomSheetViewController(
            coordinator: self,
            viewModel: PostBottomSheetViewModel(),
            boardToken: boardToken,
            filepath: filepath
        )
        let bottomSheetViewController = BottomSheetViewController(
            style: .custom(196),
            contentViewController: viewController
        )
        bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
    
    func makeMyFitftyCoordinator(boardToken: String) -> MyFitftyCoordinator {
        let coordinator = MyFitftyCoordinator(myFitftyType: .modifyMyFitfty, boardToken: boardToken)
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
    
    func makeProfileCoordinator(profileType: ProfileType, nickname: String) -> ProfileCoordinator {
        let coordinator = ProfileCoordinator(
            navigationController: navigationController,
            profileType: profileType,
            presentType: .mainProfile,
            nickname: nickname
        )
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
    
    func makeReportViewController(userToken: String, boardToken: String) -> UIViewController {
        let coordinator = ReportCoordinator(
            reportPresentType: .postUserReport,
            boardToken: boardToken,
            userToken: userToken
        )
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
        coordinator.parentCoordinator = self
        let bottomSheetViewController = BottomSheetViewController(
            style: .custom(383),
            contentViewController: coordinator.navigationController
        )
        coordinator.bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
    
}

extension PostCoordinator: PostCoordinatorInterface {
    
    func showProfile(profileType: ProfileType, nickname: String) {
        let coordinator = makeProfileCoordinator(profileType: profileType, nickname: nickname)
        coordinator.start()
    }
    
    func showBottomSheet(boardToken: String, filepath: String) {
        let bottomSheetViewController = makePostBottomSheetViewController(boardToken: boardToken, filepath: filepath)
        bottomSheetViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(bottomSheetViewController, animated: false)
    }
    
    func showModifyMyFitfty(boardToken: String) {
        navigationController.dismiss(animated: false)
        let coordinator = makeMyFitftyCoordinator(boardToken: boardToken)
        coordinator.start()
        coordinator.navigationController.modalPresentationStyle = .fullScreen
        navigationController.present(coordinator.navigationController, animated: true)
    }
    
    func showReport(userToken: String, boardToken: String) {
        let viewController = makeReportViewController(userToken: userToken, boardToken: boardToken)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
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
    
    func popToRoot() {
        navigationController.dismiss(animated: false)
        navigationController.popToRootViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func finished() {
        navigationController.popViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func finishedTapGesture() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
   
}

extension PostCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
        switch childCoordinator.type {
        case .myFitfty:
            navigationController.dismiss(animated: true) {
                childCoordinator.navigationController.viewControllers.removeAll()
            }
        default: break
        }
    }
}
