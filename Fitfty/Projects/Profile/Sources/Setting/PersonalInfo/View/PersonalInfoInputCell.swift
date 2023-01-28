//
//  PersonalInfoInputCell.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class PersonalInfoInputCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var userInputView: UserInputView = {
        let inputView = UserInputView()
        return inputView
    }()
}

extension PersonalInfoInputCell {
    
    func setUp(title: String, textField: UITextField) {
        userInputView.setUp(title: title, textField: textField)
    }
}

private extension PersonalInfoInputCell {
    
    func configure() {
        contentView.addSubviews(userInputView)
        NSLayoutConstraint.activate([
            userInputView.topAnchor.constraint(equalTo: contentView.topAnchor),
            userInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userInputView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    func reset() {
        userInputView.reset()
    }
}
