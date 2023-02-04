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
    
    private var _location: CurrentValueSubject<(longitude: Double?, latitude: Double?), Never> = .init(
        (nil, nil)
    )
    
    init(weatherRepository: WeatherRepository = DefaultWeatherRepository()) {
        self.weatherRepository = weatherRepository
    }
}

extension WeatherInfoHeaderViewModel: WeatherInfoHeaderViewModelInput {
    
    var input: WeatherInfoHeaderViewModelInput { self }
    
    func fetch() {
        currentState.send(.isLoading(true))
        LocationManager.shared.currentLocation()
            .sink(receiveValue: { [weak self] location in
                let longitude = location?.coordinate.longitude ?? 127.016702905651
                let latitude = location?.coordinate.latitude ?? 37.5893588153919
                self?._location.send((longitude, latitude))
            }).store(in: &cancellables)

        _location
            .map { ($0.longitude ?? 127.016702905651, $0.latitude ?? 37.5893588153919) }
            .sink(receiveValue: { (longitude: Double, latitude: Double) in
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
            }).store(in: &cancellables)
        
        currentState.sink(receiveValue: { [weak self] state in
            switch state {
            case .currentWeather:
                self?.currentState.send(.isLoading(false))
                
            default: return
            }
        }).store(in: &cancellables)
    }
}

extension WeatherInfoHeaderViewModel: ViewModelType {
    var state: AnyPublisher<ViewModelState, Never> {
        currentState.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    enum ViewModelState {
        case currentWeather(CurrentWeather)
        case isLoading(Bool)
    }
}
