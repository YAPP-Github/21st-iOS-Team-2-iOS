//
//  UIFont+extension.swift
//  Common
//
//  Created by Ari on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

public extension UIFont {
    
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
    
    static func systemFont(size: CGFloat, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: .largeTitle)
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        return metrics.scaledFont(for: font)
    }
    
}
