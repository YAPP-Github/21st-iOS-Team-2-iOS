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
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: titleLabel.intrinsicContentSize.width + 20,
            height: titleLabel.intrinsicContentSize.height + 10
        )
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.fTtext.color
        label.font = FitftyFont.appleSDBold(size: 18).font
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.backgroundColor = CommonAsset.Colors.ftSecondaryText.color
        label.layer.cornerRadius = 18
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
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
        contentView.addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func reset() {
        titleLabel.text = "#초기화"
        titleLabel.textColor = .systemGray
        titleLabel.backgroundColor = .clear
    }
    
}

extension StyleCell {
    
    func setUp(text: String) {
        titleLabel.text = "#\(text)"
    }
    
    func selected(in isSelected: Bool) {
        titleLabel.textColor = isSelected ? CommonAsset.Colors.fTtext.color : .systemGray
        titleLabel.backgroundColor = isSelected ? CommonAsset.Colors.ftSecondaryText.color : .clear
        
    }
    
}
