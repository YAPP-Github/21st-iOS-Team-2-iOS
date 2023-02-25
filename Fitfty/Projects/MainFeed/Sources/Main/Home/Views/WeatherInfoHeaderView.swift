//
//  WeatherInfoHeaderView.swift
//  MainFeed
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Combine
import Common

final class WeatherInfoHeaderView: UICollectionReusableView {

    private var viewModel: WeatherInfoHeaderViewModel?
    private var cancellables: Set<AnyCancellable> = .init()
    
    private lazy var weatherInfoView: WeatherInfoView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func bind() {
        viewModel?.state.sinkOnMainThread(receiveValue: { [weak self] state in
            switch state {
            case .currentWeather(let weather):
                self?.weatherInfoView.setUp(
                    temp: weather.temp,
                    condition: weather.forecast.rawValue,
                    minimum: weather.minTemp,
                    maximum: weather.maxTemp
                )
            }
        }).store(in: &cancellables)
    }
    
}

extension WeatherInfoHeaderView {
    
    func setUp(viewModel: WeatherInfoHeaderViewModel) {
        self.viewModel = viewModel
        bind()
        viewModel.input.fetch()
    }
    
}
