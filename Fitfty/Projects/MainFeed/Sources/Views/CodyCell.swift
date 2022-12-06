//
//  CodyCell.swift
//  MainFeed
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class CodyCell: UICollectionViewCell {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 336)
    }
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.image = CommonAsset.Images.sample.image
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: .zero, y: .zero, width: 300, height: 336)
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, CommonAsset.Colors.ft.color.cgColor]
        gradientLayer.locations = [0.35, 0.8]
        gradientLayer.cornerRadius = 15
        image.layer.addSublayer(gradientLayer)
        return image
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        reset()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func systemLayoutSizeFitting(
            _ targetSize: CGSize,
            withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
            verticalFittingPriority: UILayoutPriority
        ) -> CGSize {
            return CGSize(width: intrinsicContentSize.width, height: intrinsicContentSize.height)
        }
    
    private func configure() {
        contentView.addSubviews(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func reset() {
        imageView.image = nil
    }
    
}

extension CodyCell {
    func setUp(text: String) {
        
    }
}
