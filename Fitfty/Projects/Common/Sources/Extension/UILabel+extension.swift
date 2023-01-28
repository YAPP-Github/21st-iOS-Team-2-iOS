//
//  UILabel+extension.swift
//  Common
//
//  Created by Ari on 2023/01/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public extension UILabel {
    
    func editTextColor(of prefix: String, in color: UIColor) {
        guard let text = text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: prefix)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
    
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        guard let text = text else {
            return
        }
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ]
        let attrString = NSAttributedString(string: text,
                                            attributes: attributes)
        self.attributedText = attrString
    }
    
}
