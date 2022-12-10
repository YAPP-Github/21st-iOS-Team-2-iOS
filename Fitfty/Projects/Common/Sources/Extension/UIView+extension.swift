//
//  UIView+extension.swift
//  Common
//
//  Created by Ari on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

public extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
}
