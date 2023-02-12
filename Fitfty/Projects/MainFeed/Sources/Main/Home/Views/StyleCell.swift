//
//  StyleCell.swift
//  MainFeed
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class StyleCell: UICollectionViewCell {
    
    private var selectedState: Bool = false
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: titleLabel.intrinsicContentSize.width + 24,
            height: titleLabel.intrinsicContentSize.height + 16
        )
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.primaryBlueNormal.color
        label.font = FitftyFont.appleSDSemiBold(size: 13).font
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.backgroundColor = CommonAsset.Colors.primaryBlueDark.color
        label.layer.cornerRadius = 8
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.filter.image
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.isHidden = true
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
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
        contentView.addSubviews(titleLabel, filterImageView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            filterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            filterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func reset() {
        titleLabel.text = "초기화"
        titleLabel.textColor = CommonAsset.Colors.gray06.color
        titleLabel.backgroundColor = CommonAsset.Colors.gray01.color
        filterImageView.isHidden = true
    }
    
}

extension StyleCell {
    
    func setUp(text: String) {
        titleLabel.text = text
        showFilterIcon(text: text)
    }
    
    func toggle() {
        selected(in: !selectedState)
    }
    
}

private extension StyleCell {
    
    func showFilterIcon(text: String) {
        guard text == "filter" else {
            selected(in: selectedState)
            return
        }
        titleLabel.text = "X"
        titleLabel.textColor = .clear
        titleLabel.backgroundColor = .clear
        filterImageView.isHidden = false
    }
    
    func selected(in isSelected: Bool) {
        selectedState = isSelected
        titleLabel.textColor = isSelected ? CommonAsset.Colors.primaryBlueNormal.color : CommonAsset.Colors.gray06.color
        titleLabel.backgroundColor = isSelected ? CommonAsset.Colors.primaryBlueDark.color : CommonAsset.Colors.gray01.color
    }
    
}
