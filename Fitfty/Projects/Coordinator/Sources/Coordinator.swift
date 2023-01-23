//
//  Coordinator.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import UIKit
import Common

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: BaseNavigationController { get set }
    var type: CoordinatorType { get }
    var finishDelegate: CoordinatorFinishDelegate? { get set }

    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?, parent: Coordinator?) {
        guard let parent = parent,
              parent.childCoordinators.isEmpty == false else {
            return
        }
        
        for (index, coordinator) in parent.childCoordinators.enumerated() {
            if coordinator === child {
                parent.childCoordinators.remove(at: index)
                break
            }
        }
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

enum CoordinatorType {
    case app
    case login
    case tabBar
    case main
    case profile
    case address
    case weather
    case uploadCody
    case album
}
