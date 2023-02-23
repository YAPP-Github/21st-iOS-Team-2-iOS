//
//  HeaderView.swift
//  Profile
//
//  Created by 임영선 on 2022/12/09.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class MyProfileHeaderView: UICollectionReusableView {
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("설정", for: .normal)
        button.setTitleColor(CommonAsset.Colors.gray05.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 13).font
        button.layer.borderWidth = 1
        button.layer.borderColor = CommonAsset.Colors.gray02.color.cgColor
        button.layer.cornerRadius = 18
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnArrowleft.image, for: .normal)
        button.isHidden = true
        return button
    }()
    
    let profileView = ProfileView()
    let menuView = MenuView()
    private let spacingView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setButtonTarget(target: Any?, action: Selector) {
        settingButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func setUpConstraintLayout() {
        addSubviews(settingButton, profileView, menuView, spacingView, backButton)
    
        NSLayoutConstraint.activate([
            settingButton.widthAnchor.constraint(equalToConstant: 62),
            settingButton.heightAnchor.constraint(equalToConstant: 34),
            settingButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            
            profileView.topAnchor.constraint(equalTo: settingButton.bottomAnchor, constant: 12),
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            profileView.bottomAnchor.constraint(equalTo: menuView.topAnchor, constant: -24),
            
            menuView.heightAnchor.constraint(equalToConstant: 32),
            menuView.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension MyProfileHeaderView {
    
    func setBackButton(_ target: Any?, action: Selector) {
        backButton.isHidden = false
        backButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
}
