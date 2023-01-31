//
//  AddressCell.swift
//  MainFeed
//
//  Created by Ari on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class AddressCell: UICollectionViewCell {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: safeAreaLayoutGuide.layoutFrame.width,
            height: addressLabel.intrinsicContentSize.height + 28
        )
    }
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .clear
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16,
            leading: 20,
            bottom: 16,
            trailing: 20
        )
        stackView.addArrangedSubviews(addressLabel)
        return stackView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.text = "서울시, 강남구, 역삼 1동"
        label.font = FitftyFont.SFProDisplaySemibold(size: 18).font
        label.editTextColor(of: "강남", in: .black)
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
}

private extension AddressCell {
    
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
        addressLabel.text = nil
    }
    
}
