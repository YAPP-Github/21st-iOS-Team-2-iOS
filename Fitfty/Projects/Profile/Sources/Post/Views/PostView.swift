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
    
    private var isBookmark: Bool = true
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.profileSample.image
        imageView.contentMode = .scaleToFill
        return imageView
    }()
        
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplayMedium(size: 13).font
        label.textColor = CommonAsset.Colors.gray04.color
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.appleSDMedium(size: 15).font
        label.textColor = CommonAsset.Colors.gray08.color
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(CommonAsset.Images.bookmarkFill.image, for: .normal)
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        button.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var bookmarkView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        view.layer.cornerRadius = 24
        return view
    }()
   
    private lazy var postInfoView = PostInfoView()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintLayout() {
        addSubviews(postImageView, dateLabel, contentLabel, postInfoView,
                    bookmarkView, bookmarkButton)
        
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: 485),
            
            postInfoView.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            postInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postInfoView.heightAnchor.constraint(equalToConstant: 42),
            
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            contentLabel.topAnchor.constraint(equalTo: postInfoView.bottomAnchor, constant: 12),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            bookmarkView.widthAnchor.constraint(equalToConstant: 48),
            bookmarkView.heightAnchor.constraint(equalToConstant: 48),
            bookmarkView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bookmarkView.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: -20),
            
            bookmarkButton.centerXAnchor.constraint(equalTo: bookmarkView.centerXAnchor),
            bookmarkButton.centerYAnchor.constraint(equalTo: bookmarkView.centerYAnchor)
        ])
    }
    
    @objc func didTapBookmarkButton(_ sender: UIButton) {
        isBookmark = !isBookmark
        bookmarkButton.setImage(
            isBookmark ? CommonAsset.Images.bookmarkFill.image : CommonAsset.Images.bookmark.image, for: .normal
        )
    }
}

extension PostView {
    func setUp(content: String, hits: String, bookmark: String, date: String) {
        contentLabel.text = content
        dateLabel.text = date
        postInfoView.setUp(hits: hits, bookmark: bookmark, weatherTag: .freezing)
    }
}
