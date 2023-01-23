//
//  ProfileView.swift
//  Profile
//
//  Created by 임영선 on 2022/12/09.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class ProfileView: UIView {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.profileSample.image
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 52
        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplaySemibold(size: 24).font
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.appleSDMedium(size: 15).font
        label.textColor = UIColor(red: 0.512, green: 0.512, blue: 0.567, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintLayout() {
        addSubviews(imageView, nicknameLabel, contentLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 104),
            imageView.heightAnchor.constraint(equalToConstant: 104),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                               
            nicknameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nicknameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 6),
            contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension ProfileView {
    func setUp(nickname: String, content: String) {
        nicknameLabel.text = nickname
        contentLabel.text = content
    }
}
