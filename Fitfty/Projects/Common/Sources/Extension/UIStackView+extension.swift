//
//  UIStackView+extension.swift
//  Common
//
//  Created by Ari on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

public extension UIStackView {
    
    convenience init(
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment,
        distribution: UIStackView.Distribution,
        spacing: CGFloat
    ) {
        self.init(frame: .zero)
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(view)
        }
    }
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(view)
        }
    }
    
}
