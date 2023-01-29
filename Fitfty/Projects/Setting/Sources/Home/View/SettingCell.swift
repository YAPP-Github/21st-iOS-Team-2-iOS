//
//  SettingCell.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class SettingCell: UICollectionViewCell {
    
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
        let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 4)
        stackView.addArrangedSubviews(titleLabel, separator)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 24,
            leading: .zero,
            bottom: 24,
            trailing: .zero
        )
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.appleSDSemiBold(size: 16).font
        label.textColor = CommonAsset.Colors.gray07.color
        label.textAlignment = .left
        return label
    }()
    
    private lazy var separator: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .title2), scale: .small)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: configuration)?
            .withTintColor(CommonAsset.Colors.gray04.color)
            .withRenderingMode(.alwaysOriginal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = CommonAsset.Colors.gray01.color
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
}

extension SettingCell {
    
    func setUp(item: Setting) {
        titleLabel.text = item.title
        separator.isHidden = !item.isNextPage
        if item == .membershipWithdrawal {
            titleLabel.textColor = .systemRed
        }
    }
    
    func hiddenLine() {
        lineView.isHidden = true
    }
}

private extension SettingCell {
    
    func configure() {
        contentView.addSubviews(backgroundStackView, lineView)
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
    }
    
    func reset() {
        titleLabel.text = nil
        titleLabel.textColor = CommonAsset.Colors.gray07.color
        lineView.isHidden = false
    }
}
