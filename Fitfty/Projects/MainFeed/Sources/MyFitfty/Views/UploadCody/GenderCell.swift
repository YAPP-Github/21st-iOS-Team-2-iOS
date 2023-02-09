//
//  GenderCell.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/09.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import UIKit
import Common

final class GenderCell: UICollectionViewCell {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: titleLabel.intrinsicContentSize.width + 64,
            height: 43
        )
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDSemiBold(size: 13).font
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.backgroundColor = CommonAsset.Colors.gray01.color
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        return CGSize(width: intrinsicContentSize.width, height: intrinsicContentSize.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpConstraintsLayout() {
        contentView.addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension GenderCell {
    func setUp(gender: String, isSelected: Bool) {
        titleLabel.text = gender
        titleLabel.textColor = isSelected ? .white : CommonAsset.Colors.gray06.color
        titleLabel.backgroundColor = isSelected ? .black : CommonAsset.Colors.gray01.color
    }
}
