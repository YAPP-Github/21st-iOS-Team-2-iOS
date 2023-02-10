//
//  FitftyButton.swift
//  Common
//
//  Created by Watcha-Ethan on 2023/01/23.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public enum FitftyButtonStyle {
    case disabled
    case enabled
}

final public class FitftyButton: UIButton {
    private var style: FitftyButtonStyle = .disabled {
        didSet {
            switch style {
            case .disabled:
                configureDisabledStyle()
            case .enabled:
                configureEnabledStyle()
            }
        }
    }
    private lazy var buttonHeightAnchor: NSLayoutConstraint = self.heightAnchor.constraint(equalToConstant: 64)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(style: FitftyButtonStyle, title: String) {
        self.style = style
        super.init(frame: .zero)
        setButtonTitle(title)
        configureSelf()
        setHeight(64)
    }
    
    public func setStyle(_ style: FitftyButtonStyle) {
        self.style = style
    }
    
    public func setButtonTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    public func setHeight(_ height: CGFloat) {
        buttonHeightAnchor.constant = height
    }
    
    public func setButtonTarget(target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    // MARK: - Private
    
    private func configureSelf() {
        clipsToBounds = true
        layer.cornerRadius = 12
        titleLabel?.font = FitftyFont.SFProDisplayBold(size: 18).font
        NSLayoutConstraint.activate([
            buttonHeightAnchor
        ])
        
        switch style {
        case .disabled:
            configureDisabledStyle()
        case .enabled:
            configureEnabledStyle()
        }
    }

    private func configureDisabledStyle() {
        setTitleColor(CommonAsset.Colors.gray06.color, for: .normal)
        backgroundColor = CommonAsset.Colors.gray03.color
        isEnabled = false
    }

    private func configureEnabledStyle() {
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        isEnabled = true
    }
}
