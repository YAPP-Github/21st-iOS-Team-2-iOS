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
    
    convenience init(title: String, textField: UITextField) {
        self.init(frame: .zero)
        configure()
        setUp(title: title, textField: textField)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUp(title: String, textField: UITextField) {
        titleLabel.text = title
        addArrangedSubviews(textField)
    }
    
    func reset() {
        arrangedSubviews.last?.removeFromSuperview()
    }
}

private extension UserInputView {
    
    func configure() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 4
        addArrangedSubviews(titleLabel)
    }
}
