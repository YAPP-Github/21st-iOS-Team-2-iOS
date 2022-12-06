//
//  WeatherInfoHeaderView.swift
//  MainFeed
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

final class WeatherInfoHeaderView: UICollectionReusableView {

    private lazy var weatherInfoView: WeatherInfoView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        addSubviews(weatherInfoView)
        NSLayoutConstraint.activate([
            weatherInfoView.topAnchor.constraint(equalTo: topAnchor),
            weatherInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension WeatherInfoHeaderView {
    
    func setUp(temp: Int, condition: String, minimum: Int, maximum: Int) {
        weatherInfoView.setUp(temp: temp, condition: condition, minimum: minimum, maximum: maximum)
    }
}
