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
        label.text = "iloveios2"
        label.font = FitftyFont.SFProDisplaySemibold(size: 24).font
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요! 반갑습니다"
        label.font = FitftyFont.appleSDMedium(size: 15).font
        label.textColor = UIColor(red: 0.512, green: 0.512, blue: 0.567, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.217, green: 0.671, blue: 1, alpha: 0.1)
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.078, green: 0.364, blue: 0.571, alpha: 1), for: .normal)
        button.setTitle("팔로우 0", for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 13).font
        return button
    }()
    
    private lazy var followerButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.078, green: 0.364, blue: 0.571, alpha: 1), for: .normal)
        button.setTitle("팔로워 0", for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 13).font
        return button
    }()
    
    private lazy var dotLabel: UILabel = {
        let label = UILabel()
        label.text = "ㆍ"
        label.textColor = UIColor(red: 0.227, green: 0.227, blue: 0.235, alpha: 1)
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
        [imageView, nicknameLabel, contentLabel, followView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([$0.centerXAnchor.constraint(equalTo: centerXAnchor)])
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 104),
            imageView.heightAnchor.constraint(equalToConstant: 104),
            
            nicknameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            contentLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 6),
            
            followView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
            followView.widthAnchor.constraint(equalToConstant: 144),
            followView.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        [followButton, followerButton, dotLabel].forEach {
            followView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dotLabel.centerXAnchor.constraint(equalTo: followView.centerXAnchor),
            dotLabel.centerYAnchor.constraint(equalTo: followView.centerYAnchor),
            
            followButton.rightAnchor.constraint(equalTo: dotLabel.leftAnchor, constant: -1),
            followButton.centerYAnchor.constraint(equalTo: followView.centerYAnchor),
            
            followerButton.leftAnchor.constraint(equalTo: dotLabel.rightAnchor, constant: 1),
            followerButton.centerYAnchor.constraint(equalTo: followView.centerYAnchor)
        ])
    }
}

extension ProfileView {
    func setUp(nickname: String, content: String, follow: Int, follower: Int) {
        nicknameLabel.text = nickname
        contentLabel.text = content
        followButton.setTitle("팔로우 \(follow)", for: .normal)
        followerButton.setTitle("팔로워 \(follower)", for: .normal)
    }
}
