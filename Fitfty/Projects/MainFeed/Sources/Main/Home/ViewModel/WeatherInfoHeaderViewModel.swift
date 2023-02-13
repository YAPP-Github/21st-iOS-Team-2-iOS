//
//  WeatherInfoHeaderViewModel.swift
//  MainFeed
//
//  Created by Ari on 2023/02/03.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common
import Core

protocol WeatherInfoHeaderViewModelInput {
    var input: WeatherInfoHeaderViewModelInput { get }
    func fetch()
}

final class WeatherInfoHeaderViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let weatherRepository: WeatherRepository
    private let userManager: UserManager
    
    init(
        weatherRepository: WeatherRepository,
        userManager: UserManager
    ) {
        self.weatherRepository = weatherRepository
        self.userManager = userManager
    }
}

extension WeatherInfoHeaderViewModel: WeatherInfoHeaderViewModelInput {
    
    var input: WeatherInfoHeaderViewModelInput { self }
    
    func fetch() {
        userManager.location
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] (longitude: Double, latitude: Double) in
                self?.getCurrentWeather(longitude: longitude, latitude: latitude)
            }).store(in: &cancellables)
    }
}

extension WeatherInfoHeaderViewModel: ViewModelType {
    var state: AnyPublisher<ViewModelState, Never> {
        currentState.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    enum ViewModelState {
        case currentWeather(CurrentWeather)
    }
}

private extension WeatherInfoHeaderViewModel {
    
    func getCurrentWeather(longitude: Double, latitude: Double) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let currentWeather = try await self.weatherRepository.fetchCurrentWeather(
                    longitude: longitude.description, latitude: latitude.description
                )
                self.currentState.send(.currentWeather(currentWeather))
            } catch {
                Logger.debug(error: error, message: "현재 날씨 가져오기 실패")
            }
        }
    }
}
