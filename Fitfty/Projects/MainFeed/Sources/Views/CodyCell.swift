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
    
    private lazy var codyImageView: UIImageView = {
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
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 8)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(profileImageView, profileInfoStackView)
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = CommonAsset.Images.sample.image
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        return image
    }()
    
    private lazy var profileInfoStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .leading, distribution: .fill, spacing: 2)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(nameLabel, dateLabel)
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(for: .footnote, weight: .bold)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.text = "iloveiso2"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.ftSecondaryText.color
        label.font = .preferredFont(for: .footnote, weight: .semibold)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.text = "4시간"
        return label
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
        contentView.addSubviews(codyImageView, profileStackView)
        NSLayoutConstraint.activate([
            codyImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            codyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            codyImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            codyImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileStackView.leadingAnchor.constraint(equalTo: codyImageView.leadingAnchor, constant: 20),
            profileStackView.bottomAnchor.constraint(equalTo: codyImageView.bottomAnchor, constant: -20)
        ])
    }
    
    private func reset() {
        codyImageView.image = nil
    }
    
}

extension CodyCell {
    func setUp() {
        
    }
}
