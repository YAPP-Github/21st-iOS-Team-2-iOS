//
//  ProfileSettingCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Setting
import Common
import Core

final class ProfileSettingCoordinator: Coordinator {
    
    var type: CoordinatorType { .profileSetting }
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var bottomSheetDelegate: BottomSheetViewControllerDelegate?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeProfileSettingViewController()
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

private extension ProfileSettingCoordinator {
    
    func makeProfileSettingViewController() -> UIViewController {
        let viewController = ProfileSettingViewController(
            coordinator: self,
            viewModel: ProfileSettingViewModel(
                repository: DefaultSettingRepository()
            )
        )
        return viewController
    }
    
    func makeImagePickerController(_ viewController: UIViewController) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = viewController as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
}

extension ProfileSettingCoordinator: ProfileSettingCoordinatorInterface {
    
    func dismiss() {
        bottomSheetDelegate?.dismissBottomSheet {
            self.navigationController.viewControllers.removeAll()
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
    
    func showImagePicker(_ viewController: UIViewController) {
        let viewController = makeImagePickerController(viewController)
        navigationController.visibleViewController?.present(viewController, animated: true)
    }
}
