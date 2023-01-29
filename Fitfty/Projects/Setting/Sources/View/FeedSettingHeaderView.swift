//
//  FeedSettingHeaderView.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class FeedSettingHeaderView: UICollectionReusableView {
    
    override var intrinsicContentSize: CGSize {
        return titleLabel.intrinsicContentSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDSemiBold(size: 16).font
        label.textAlignment = .left
        return label
    }()
}

extension FeedSettingHeaderView {
    
    func setUp(title: String) {
        titleLabel.text = title
    }
}

private extension FeedSettingHeaderView {
    
    func configure() {
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
