//
//  HeaderView.swift
//  Profile
//
//  Created by 임영선 on 2022/12/09.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class HeaderView: UICollectionReusableView {
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("설정", for: .normal)
        button.setTitleColor(UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1), for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 13).font
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.918, alpha: 1).cgColor
        button.layer.cornerRadius = 18
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
    
    private func setUpConstraintLayout() {
        [settingButton, profileView, menuView, spacingView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            settingButton.widthAnchor.constraint(equalToConstant: 62),
            settingButton.heightAnchor.constraint(equalToConstant: 34),
            settingButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            settingButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            profileView.topAnchor.constraint(equalTo: settingButton.bottomAnchor, constant: 12),
            profileView.heightAnchor.constraint(equalToConstant: 223),
            profileView.leftAnchor.constraint(equalTo: leftAnchor),
            profileView.rightAnchor.constraint(equalTo: rightAnchor),
            
            menuView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 24),
            menuView.heightAnchor.constraint(equalToConstant: 72),
            menuView.leftAnchor.constraint(equalTo: leftAnchor),
            menuView.rightAnchor.constraint(equalTo: rightAnchor),
            
            spacingView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
            spacingView.heightAnchor.constraint(equalToConstant: 24),
            spacingView.leftAnchor.constraint(equalTo: leftAnchor),
            spacingView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
