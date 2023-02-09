//
//  TabCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

enum TabBarPage {
    
    case weather
    case createCody
    case profile
    
    init?(index: Int) {
        switch index {
        case 0: self = .weather
        case 1: self = .createCody
        case 2: self = .profile
        default: return nil
        }
    }
    
    var pageOrderNumber: Int {
        switch self {
        case .weather: return 0
        case .createCody: return 1
        case .profile: return 2
        }
    }
    
    var pageIconImage: UIImage? {
        switch self {
        case .weather: return CommonAsset.Images.iconSun.image.withRenderingMode(.alwaysOriginal)
        case .createCody: return CommonAsset.Images.iconAdd.image.withRenderingMode(.alwaysOriginal)
        case .profile: return CommonAsset.Images.iconProfile.image.withRenderingMode(.alwaysOriginal)
        }
    }
    
    public var selectedIconImage: UIImage? {
        switch self {
        case .weather: return CommonAsset.Images.iconSunFill.image.withRenderingMode(.alwaysOriginal)
        case .createCody: return CommonAsset.Images.iconAdd.image.withRenderingMode(.alwaysOriginal)
        case .profile: return CommonAsset.Images.iconProfileFill.image.withRenderingMode(.alwaysOriginal)
        }
    }
    
}

protocol TabCoordinatorProtocol: Coordinator {
    
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
    
}

final class TabCoordinator: NSObject, Coordinator, TabCoordinatorProtocol {
    
    var type: CoordinatorType { .tabBar }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var tabBarController: UITabBarController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    required init(
        _ navigationController: BaseNavigationController,
        tabBarController: UITabBarController = TabBarController()
    ) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
    
    func start() {
        let pages: [TabBarPage] = [.weather, .createCody, .profile]
            .sorted(by: { $0.pageOrderNumber < $1.pageOrderNumber })
        
        let controllers: [BaseNavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.tabBar.isTranslucent = false
        tabBarController.view.backgroundColor = .white
        selectPage(.weather)
        
        navigationController.viewControllers = [tabBarController]
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    private func getTabController(_ page: TabBarPage) -> BaseNavigationController {
        switch page {
        case .weather:
            let coordinator = MainCoordinator()
            childCoordinators.append(coordinator)
            coordinator.start()
            let tabBarItem =  UITabBarItem.init(
                title: nil,
                image: page.selectedIconImage,
                tag: page.pageOrderNumber
            )
            tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 40, bottom: -12, right: -40)
            coordinator.navigationController.tabBarItem = tabBarItem
            tabBarController.addChild(coordinator.navigationController)
            
        case .createCody:
            let dummyController = UINavigationController()
            let tabBarItem =  UITabBarItem.init(
                title: nil,
                image: page.pageIconImage,
                tag: page.pageOrderNumber
            )
            dummyController.tabBarItem = tabBarItem
            tabBarItem.imageInsets = UIEdgeInsets(top: 13, left: 0, bottom: -15, right: 0)
            tabBarController.addChild(dummyController)
            
        case .profile:
            let coordinator = ProfileCoordinator(profileType: .myProfile, presentType: .tabProfile)
            childCoordinators.append(coordinator)
            coordinator.start()
            let tabBarItem =  UITabBarItem.init(
                title: nil,
                image: page.pageIconImage,
                tag: page.pageOrderNumber
            )
            tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: -40, bottom: -12, right: 40)
            coordinator.navigationController.tabBarItem = tabBarItem
            tabBarController.addChild(coordinator.navigationController)
        }
        
        return navigationController
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else {
            return
        }
        tabBarController.selectedIndex = page.pageOrderNumber
    }
    
    func currentPage() -> TabBarPage? {
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }
    
}

extension TabCoordinator: UITabBarControllerDelegate {
    
    public func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard let indexOfTab = tabBarController.viewControllers?.firstIndex(of: viewController),
              let tabBar = TabBarPage(index: indexOfTab) else {
            return true
        }
        if tabBar == .createCody {
            let coordinator = MyFitftyCoordinator(myFitftyType: .uploadMyFitfty)
            childCoordinators.append(coordinator)
            coordinator.finishDelegate = self
            coordinator.parentCoordinator = self
            coordinator.start()
            coordinator.navigationController.modalPresentationStyle = .fullScreen
            tabBarController.present(coordinator.navigationController, animated: true)
            return false
        }
        return true
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabBar = TabBarPage(index: tabBarController.selectedIndex) else {
            return
        }
        switch tabBar {
        case .weather:
            tabBarController.tabBar.items?[tabBar.pageOrderNumber].image = tabBar.selectedIconImage
            tabBarController.tabBar.items?[TabBarPage.profile.pageOrderNumber].image = TabBarPage.profile.pageIconImage
            
        case .profile:
            tabBarController.tabBar.items?[tabBar.pageOrderNumber].image = tabBar.selectedIconImage
            tabBarController.tabBar.items?[TabBarPage.weather.pageOrderNumber].image = TabBarPage.weather.pageIconImage
            
        default:
            return
        }
    }
    
}

extension TabCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childDidFinish(childCoordinator, parent: self)
        switch childCoordinator.type {
        case .myFitfty:
            tabBarController.dismiss(animated: true) {
                childCoordinator.navigationController.viewControllers.removeAll()
            }
        default: break
        }
    }
}
