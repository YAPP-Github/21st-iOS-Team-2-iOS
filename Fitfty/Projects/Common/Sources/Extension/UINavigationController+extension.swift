//
//  UINavigationController+extension.swift
//  Common
//
//  Created by 임영선 on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public extension UINavigationController {
    func setCustomBackButton() {
        navigationBar.topItem?.title = ""
        navigationBar.backIndicatorImage = CommonAsset.Images.btnArrowleft.image
        navigationBar.backIndicatorTransitionMaskImage = CommonAsset.Images.btnArrowleft.image
        navigationBar.tintColor = .black
    }
}
