//
//  InputView.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class UserInputView: UIStackView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = FitftyFont.appleSDSemiBold(size: 13).font
        label.textColor = CommonAsset.Colors.gray07.color
        return label
    }()
    
    init(title: String, textField: UITextField) {
        super.init(frame: .zero)
        titleLabel.text = title
        configure()
        addArrangedSubviews(titleLabel, textField)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

private extension UserInputView {
    
    func configure() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 4
    }
}
