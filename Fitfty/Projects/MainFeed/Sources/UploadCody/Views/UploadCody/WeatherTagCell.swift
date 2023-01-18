//
//  WeatherTagCell.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class WeatherTagCell: UICollectionViewCell {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: titleLabel.intrinsicContentSize.width + 25,
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

extension WeatherTagCell {
    func setUp(weahterTag: WeatherTag, isSelected: Bool) {
        titleLabel.text = weahterTag.weatherTagString
        titleLabel.textColor = isSelected ? weahterTag.textColor : CommonAsset.Colors.gray06.color
        titleLabel.backgroundColor = isSelected ? weahterTag.backgroundColor : CommonAsset.Colors.gray01.color
    }
}