//
//  PostView.swift
//  Profile
//
//  Created by 임영선 on 2022/12/18.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class PostView: UIView {
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.profileSample.image
        imageView.contentMode = .scaleToFill
        return imageView
    }()
        
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplayBold(size: 15).font
        return label
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.appleSDMedium(size: 15).font
        label.textColor = UIColor(red: 0.388, green: 0.388, blue: 0.4, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentView = UIView()
    private lazy var dateView = UIView()
    private lazy var postInfoView = PostInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintLayout() {
        [postImageView, dateView, seperatorView, contentView, dateLabel, contentLabel, postInfoView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: topAnchor),
            postImageView.leftAnchor.constraint(equalTo: leftAnchor),
            postImageView.rightAnchor.constraint(equalTo: rightAnchor),
            postImageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.7),
            
            postInfoView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            postInfoView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            
            dateView.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            dateView.leftAnchor.constraint(equalTo: leftAnchor),
            dateView.rightAnchor.constraint(equalTo: rightAnchor),
            dateView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.08),
            
            dateLabel.leftAnchor.constraint(equalTo: dateView.leftAnchor, constant: 20),
            dateLabel.centerYAnchor.constraint(equalTo: dateView.centerYAnchor),
            
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            seperatorView.topAnchor.constraint(equalTo: dateView.bottomAnchor),
            seperatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            seperatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: seperatorView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.22),
            
            contentLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            contentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
    }
}

extension PostView {
    func setUp(content: String, hits: String, bookmark: String, date: String) {
        contentLabel.text = content
        dateLabel.text = date
        postInfoView.setUp(hits: hits, bookmark: bookmark)
    }
}
