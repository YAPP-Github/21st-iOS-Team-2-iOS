//
//  LoadingView.swift
//  Common
//
//  Created by Ari on 2023/02/04.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public final class LoadingView: UIActivityIndicatorView {
    
    public convenience init(
        backgroundColor: UIColor,
        alpha: CGFloat,
        style: UIActivityIndicatorView.Style = .large
    ) {
        self.init(frame: .zero)
        self.style = style
        self.backgroundColor = backgroundColor
        self.alpha = alpha
        self.color = CommonAsset.Colors.primaryBlueLight.color
    }
}
