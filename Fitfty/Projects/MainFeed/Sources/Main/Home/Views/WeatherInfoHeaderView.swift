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
    
    private lazy var loadingIndicatorView: LoadingView = {
        let loadingView: LoadingView = .init(backgroundColor: .white, alpha: 1, style: .medium)
        loadingView.startAnimating()
        return loadingView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(weatherInfoView, loadingIndicatorView)
        NSLayoutConstraint.activate([
            weatherInfoView.topAnchor.constraint(equalTo: topAnchor),
            weatherInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherInfoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalTo: widthAnchor),
            loadingIndicatorView.heightAnchor.constraint(equalTo: heightAnchor),
            loadingIndicatorView.topAnchor.constraint(equalTo: topAnchor),
            loadingIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor)
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
                
            case .isLoading(let isLoading):
                isLoading ? self?.loadingIndicatorView.startAnimating() : self?.loadingIndicatorView.stopAnimating()
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
