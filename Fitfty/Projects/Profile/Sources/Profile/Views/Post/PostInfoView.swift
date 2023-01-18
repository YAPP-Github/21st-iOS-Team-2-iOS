//
//  PostInfoView.swift
//  Profile
//
//  Created by 임영선 on 2022/12/18.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class PostInfoView: UIStackView {
    
    private lazy var hitsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eye.fill")
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var hitsLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplayMedium(size: 13).font
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bookmark.fill")
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplayMedium(size: 13).font
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStackView()
        setUpConstraintsLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpStackView() {
        self.axis = .horizontal
        self.alignment = .fill
        self.spacing = 5
    }
    
    private func setUpConstraintsLayout() {
        addArrangedSubviews(hitsImageView, hitsLabel, bookmarkImageView, bookmarkLabel)
       
        NSLayoutConstraint.activate([
            hitsImageView.heightAnchor.constraint(equalToConstant: 14),
            hitsImageView.widthAnchor.constraint(equalToConstant: 14),

            bookmarkImageView.heightAnchor.constraint(equalToConstant: 12),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 9.33)
        ])
        self.setCustomSpacing(11, after: hitsLabel)
    }
}

extension PostInfoView {
    func setUp(hits: String, bookmark: String) {
        hitsLabel.text = hits.insertComma
        bookmarkLabel.text = bookmark.insertComma
    }
}
