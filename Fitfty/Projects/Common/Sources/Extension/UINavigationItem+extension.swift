//
//  UINavigationItem+extension.swift
//  Common
//
//  Created by 임영선 on 2022/12/28.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

public extension UINavigationItem {
    
    func setCustomRightBarButton(
        _ target: Any?,
        action: Selector,
        image: CommonImages.Image,
        size: CGFloat
    ) {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = .black
            
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        if let customView = barButtonItem.customView {
            NSLayoutConstraint.activate([
                customView.heightAnchor.constraint(equalToConstant: size),
                customView.widthAnchor.constraint(equalToConstant: size)
            ])
        }
          
        if let viewController = target as? UIViewController {
            viewController.navigationItem.rightBarButtonItem = barButtonItem
        }
    }

    func setCustomBackButton(_ viewController: UIViewController) {
        let navigationBar = viewController.navigationController?.navigationBar
        navigationBar?.topItem?.title = ""
        navigationBar?.backIndicatorImage = CommonAsset.Images.btnArrowleft.image
        navigationBar?.backIndicatorTransitionMaskImage = CommonAsset.Images.btnArrowleft.image
        navigationBar?.tintColor = .black
    }

}
