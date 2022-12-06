//
//  HeaderView.swift
//  MainFeed
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

final class HeaderView: UICollectionReusableView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(for: .title1, weight: .bold)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "지금 날씨 코디 추천"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17)
        ])
    }
}
