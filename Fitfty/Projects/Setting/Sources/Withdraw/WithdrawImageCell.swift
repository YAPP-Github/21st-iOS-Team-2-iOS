//
//  WithdrawImageCell.swift
//  Setting
//
//  Created by Watcha-Ethan on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Common

final class WithdrawImageCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 221, height: 252)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setUp(item: Int) {
        switch item {
        case 0: imageView.image = CommonAsset.Images.introImage1.image
        case 1: imageView.image = CommonAsset.Images.introImage2.image
        case 2: imageView.image = CommonAsset.Images.introImage3.image
        default: imageView.image = CommonAsset.Images.introImage1.image
        }
    }

    private func configure() {
        contentView.addSubviews(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
