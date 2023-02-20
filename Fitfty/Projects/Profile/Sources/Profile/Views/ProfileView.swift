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
        imageView.contentMode = .scaleAspectFill
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
        label.textColor = CommonAsset.Colors.gray05.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
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
            nicknameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 6),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ProfileView {
    func setUp(nickname: String, content: String, filepath: String?, refresh: Bool) {
        if let filepath = filepath {
            let url = URL(string: filepath)
            if refresh {
                imageView.kf.setImage(
                    with: url,
                    placeholder: CommonAsset.Images.profileDummy.image,
                    options: [.forceRefresh, .transition(.fade(0.1))]
                )
            } else {
                imageView.kf.setImage(with: url)
            }
        } else {
            imageView.image = CommonAsset.Images.profileDummy.image
        }
        nicknameLabel.text = nickname
        contentLabel.text = content
    }
}
