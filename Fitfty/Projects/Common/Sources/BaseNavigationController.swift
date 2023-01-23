//
//  BaseNavigationController.swift
//  Common
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public final class BaseNavigationController: UINavigationController {
    
    private var duringTransition = false
    private var disabledPopVCs: [UIViewController.Type] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringTransition = true
        
        super.pushViewController(viewController, animated: animated)
    }
    
}

extension BaseNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        self.duringTransition = false
    }
    
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer,
              let topVC = topViewController else {
            return true // default value
        }
        
        return viewControllers.count > 1 && duringTransition == false && isPopGestureEnable(topVC)
    }
    
    private func isPopGestureEnable(_ topVC: UIViewController) -> Bool {
        for viewController in disabledPopVCs
        where String(describing: type(of: topVC)) == String(describing: viewController) {
            return false
        }
        return true
    }
    
}
