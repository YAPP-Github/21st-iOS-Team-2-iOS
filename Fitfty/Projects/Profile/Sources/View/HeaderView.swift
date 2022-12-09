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
    static let identifier = "headerView"
    
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

        settingButton.widthAnchor.constraint(equalToConstant: 62).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        settingButton.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        settingButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        profileView.topAnchor.constraint(equalTo: settingButton.bottomAnchor, constant: 12).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 223).isActive = true
        profileView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        profileView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        menuView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 24).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        menuView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        spacingView.topAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
        spacingView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        spacingView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        spacingView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
    }
}
