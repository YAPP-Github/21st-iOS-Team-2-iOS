//
//  TabBarController.swift
//  MainFeed
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

public final class TabBarController: UITabBarController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, TabBar.self)
        applyShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class TabBar: UITabBar {
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width, height: 96)
        }
    }
    
    private func applyShadow() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 0.33
    }
    
}
