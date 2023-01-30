//
//  FitftyTextField.swift
//  Common
//
//  Created by Watcha-Ethan on 2023/01/24.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public enum FitftyTextFieldStyle {
    case normal
    case focused
}

final public class FitftyTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    private var style: FitftyTextFieldStyle = .normal {
        didSet {
            switch style {
            case .normal:
                configureNormalStyle()
            case .focused:
                configureFocusedStyle()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(style: FitftyTextFieldStyle, placeHolderText: String) {
        self.style = style
        super.init(frame: .zero)
        configureSelf()
        placeholder = placeHolderText
    }
    
    public func setStyle(style: FitftyTextFieldStyle) {
        self.style = style
    }
    
    // MARK: - Private
    
    private func configureSelf() {
        clipsToBounds = true
        layer.cornerRadius = 12
        textColor = CommonAsset.Colors.gray08.color
        backgroundColor = CommonAsset.Colors.gray01.color
        heightAnchor.constraint(equalToConstant: 64).isActive = true
           
        switch style {
        case .normal:
            configureNormalStyle()
        case .focused:
            configureFocusedStyle()
        }
    }
    
    private func configureNormalStyle() {
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }

    private func configureFocusedStyle() {
        layer.borderWidth = 2
        layer.borderColor = CommonAsset.Colors.primaryBlueNormal.color.cgColor
    }
}
