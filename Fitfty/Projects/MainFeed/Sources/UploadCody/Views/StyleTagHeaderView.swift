//
//  StyleTagHeaderView.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

class StyleTagHeaderView: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "스타일 태그를 골라주세요."
        label.font = FitftyFont.appleSDBold(size: 16).font
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintsLayout() {
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
