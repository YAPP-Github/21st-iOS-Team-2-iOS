//
//  InputView.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class UserInputView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = FitftyFont.appleSDSemiBold(size: 13).font
        label.textColor = CommonAsset.Colors.gray07.color
        return label
    }()
    
    convenience init(title: String, textField: UITextField) {
        self.init(frame: .zero)
        setUp(title: title, textField: textField)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    func setUp(title: String, textField: UITextField) {
        addSubviews(titleLabel, textField)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        titleLabel.text = title
    }
    
    func reset() {
        subviews.last?.removeFromSuperview()
    }
}
