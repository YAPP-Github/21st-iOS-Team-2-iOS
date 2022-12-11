//
//  TabBarController.swift
//  MainFeed
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

public enum TabBarPage {
    
    case weather
    case createCody
    case profile
    
    public init?(index: Int) {
        switch index {
        case 0: self = .weather
        case 1: self = .createCody
        case 2: self = .profile
        default: return nil
        }
    }
    
    public var pageOrderNumber: Int {
        switch self {
        case .weather: return 0
        case .createCody: return 1
        case .profile: return 2
        }
    }
    
    public var pageIconImage: UIImage? {
        switch self {
        case .weather: return CommonAsset.Images.iconSunFill.image.withRenderingMode(.alwaysOriginal)
        case .createCody: return CommonAsset.Images.iconAdd.image.withRenderingMode(.alwaysOriginal)
        case .profile: return CommonAsset.Images.iconProfile.image.withRenderingMode(.alwaysOriginal)
        }
    }
    
}

public final class TabBarController: UITabBarController {
    
    private lazy var sunImage = CommonAsset.Images.iconSun.image.withRenderingMode(.alwaysOriginal)
    private lazy var sunFillImage = CommonAsset.Images.iconSunFill.image.withRenderingMode(.alwaysOriginal)
    private lazy var profileImage = CommonAsset.Images.iconProfile.image.withRenderingMode(.alwaysOriginal)
    private lazy var profileFillImage = CommonAsset.Images.iconProfileFill.image.withRenderingMode(.alwaysOriginal)
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, TabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class TabBar: UITabBar {
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width, height: 96)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabBar = TabBarPage(index: tabBarController.selectedIndex) else {
            return
        }
        switch tabBar {
        case .weather:
            tabBarController.tabBar.items?[tabBar.pageOrderNumber].image = sunFillImage
            tabBarController.tabBar.items?[TabBarPage.profile.pageOrderNumber].image = profileImage
            
        case .profile:
            tabBarController.tabBar.items?[tabBar.pageOrderNumber].image = profileFillImage
            tabBarController.tabBar.items?[TabBarPage.weather.pageOrderNumber].image = sunImage
            
        default:
            return
        }
    }
    
}
