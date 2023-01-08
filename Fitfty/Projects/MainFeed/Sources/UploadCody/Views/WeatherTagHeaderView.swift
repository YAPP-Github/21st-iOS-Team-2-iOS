//
//  WeatherTagHeaderView.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class WeatherTagHeaderView: UICollectionReusableView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨 태그를 골라주세요."
        label.font = FitftyFont.appleSDBold(size: 16).font
        return label
    }()
    
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 업로드하면 촬영한 날의 날씨 정보를 자동으로 불러와요."
        label.font = FitftyFont.appleSDMedium(size: 14).font
        label.textColor = CommonAsset.Colors.gray05.color
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
        addSubviews(titleLabel, weatherLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            weatherLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            weatherLabel.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }
}
