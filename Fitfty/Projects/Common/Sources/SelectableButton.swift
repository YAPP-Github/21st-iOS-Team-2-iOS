//
//  SelectableButton.swift
//  Common
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public enum SelectableButtonStyle {
    case normal
    case isPressed
}

final public class SelectableButton: UIButton {
    private var style: SelectableButtonStyle = .normal {
        didSet {
            switch style {
            case .normal:
                configureNormalStyle()
            case .isPressed:
                configureIsPressedStyle()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(style: SelectableButtonStyle, title: String) {
        self.style = style
        super.init(frame: .zero)
        setButtonTitle(title)
        configureSelf()
    }
    
    public func setStyle(_ style: SelectableButtonStyle) {
        self.style = style
    }
    
    public func setButtonTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    @objc
    private func didTapButton() {
        style = style == .normal ? .isPressed : .normal
    }
    
    private func configureSelf() {
        clipsToBounds = true
        layer.cornerRadius = 12
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        titleLabel?.font = FitftyFont.SFProDisplayBold(size: 20).font
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        switch style {
        case .normal:
            configureNormalStyle()
        case .isPressed:
            configureIsPressedStyle()
        }
    }
    
    private func configureNormalStyle() {
        setTitleColor(CommonAsset.Colors.gray04.color, for: .normal)
        backgroundColor = CommonAsset.Colors.gray01.color
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        
    }

    private func configureIsPressedStyle() {
        setTitleColor(CommonAsset.Colors.primaryBlueNormal.color, for: .normal)
        backgroundColor = CommonAsset.Colors.primaryBlueDark.color
        layer.borderWidth = 2
        layer.borderColor = CommonAsset.Colors.primaryBlueLight.color.cgColor
    }
}
