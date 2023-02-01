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
    var profileType: ProfileType?
    var presentType: ProfilePresentType?
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationConrtoller: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makePostViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension PostCoordinator {
   
    func makePostViewController() -> UIViewController {
        if let profileType = profileType,
           let presentType = presentType {
            let viewController = PostViewController(
                coordinator: self,
                profileType: profileType,
                presentType: presentType
            )
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
        return UIViewController()
    }
    
    func makeProfileBottomSheetViewController() -> UIViewController {
        let viewController = MyPostBottomSheetViewController(coordinator: self)
        let bottomSheetViewController = BottomSheetViewController(
            style: .custom(196),
            contentViewController: viewController
        )
        bottomSheetDelegate = bottomSheetViewController
        return bottomSheetViewController
    }
    
    func makeUploadCodyCoordinator() -> UploadCodyCoordinator {
        let coordinator = UploadCodyCoordinator()
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
    
    func makeProfileCoordinator() -> ProfileCoordinator {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        coordinator.presentType = presentType
        coordinator.profileType = profileType
        coordinator.parentCoordinator = self
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        return coordinator
    }
}

extension PostCoordinator: PostCoordinatorInterface {
    
    func showProfile() {
        let coordinator = makeProfileCoordinator()
        coordinator.presentType = .mainProfile
        coordinator.start()
    }
    
    func showBottomSheet() {
        let bottomSheetViewController = makeProfileBottomSheetViewController()
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
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func finished() {
        navigationController.popViewController(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
   
}

extension PostCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
    }
}
