//
//  TabCoordinator.swift
//  Coordinator
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common
import MainFeed

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

final class TabCoordinator: NSObject, Coordinator, TabCoordinatorProtocol, UITabBarControllerDelegate {
    var type: CoordinatorType { .tabBar }
    var finishDelegate: CoordinatorFinishDelegate?
    
    var tabBarController: UITabBarController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    required init(
        _ navigationController: UINavigationController,
        tabBarController: UITabBarController = TabBarController()
    ) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
    
    func start() {
        let pages: [TabBarPage] = [.weather, .createCody, .profile]
            .sorted(by: { $0.pageOrderNumber < $1.pageOrderNumber })
        
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.tabBar.isTranslucent = false
        tabBarController.view.backgroundColor = .white
        selectPage(.weather)
        
        navigationController.viewControllers = [tabBarController]
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        switch page {
        case .weather:
            let coordinator = MainCoordinator()
            coordinator.start()
            let tabBarItem =  UITabBarItem.init(
                title: nil,
                image: page.pageIconImage,
                tag: page.pageOrderNumber
            )
            tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 40, bottom: -12, right: -40)
            coordinator.navigationController.tabBarItem = tabBarItem
            tabBarController.addChild(coordinator.navigationController)
            
        case .createCody:
            let navigationController = UINavigationController()
            let tabBarItem =  UITabBarItem.init(
                title: nil,
                image: page.pageIconImage,
                tag: page.pageOrderNumber
            )
            navigationController.tabBarItem = tabBarItem
            tabBarItem.imageInsets = UIEdgeInsets(top: 13, left: 0, bottom: -15, right: 0)
            tabBarController.addChild(navigationController)
            
        case .profile:
            let navigationController = UINavigationController()
            let tabBarItem =  UITabBarItem.init(
                title: nil,
                image: page.pageIconImage,
                tag: page.pageOrderNumber
            )
            tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: -40, bottom: -12, right: 40)
            navigationController.tabBarItem = tabBarItem
            tabBarController.addChild(navigationController)
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
