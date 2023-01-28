//
//  FeedSettingCell.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class FeedSettingCell: UICollectionViewCell {
    
    private var selectedState: Bool = false
    
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
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: .zero)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 12.5,
            leading: 32,
            bottom: 12.5,
            trailing: 32
        )
        stackView.backgroundColor = CommonAsset.Colors.primaryBlueDark.color
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 20
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = CommonAsset.Colors.primaryBlueLight.color.cgColor
        stackView.addArrangedSubviews(titleLabel)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.primaryBlueNormal.color
        label.font = FitftyFont.appleSDSemiBold(size: 13).font
        label.textAlignment = .center
        return label
    }()
    
}

extension FeedSettingCell {
    
    func setUp(title: String, isSelected: Bool) {
        titleLabel.text = title
        highlight(isSelected)
    }
    
    func toggle() {
        highlight(!selectedState)
    }
}

private extension FeedSettingCell {
    
    func configure() {
        contentView.addSubviews(backgroundStackView)
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func reset() {
        titleLabel.text = nil
        highlight(false)
    }
    
    func highlight(_ isSelected: Bool) {
        selectedState = isSelected
        backgroundStackView.backgroundColor = isSelected ?
                                              CommonAsset.Colors.primaryBlueDark.color :
                                              CommonAsset.Colors.gray01.color
        backgroundStackView.layer.borderColor = isSelected ?
                                                CommonAsset.Colors.primaryBlueLight.color.cgColor :
                                                UIColor.clear.cgColor
        titleLabel.textColor = isSelected ?
                               CommonAsset.Colors.primaryBlueNormal.color :
                               CommonAsset.Colors.gray06.color
    }
}
