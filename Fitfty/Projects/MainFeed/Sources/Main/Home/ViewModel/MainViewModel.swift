//
//  MainViewModel.swift
//  MainFeed
//
//  Created by Ari on 2022/12/18.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common
import Core

protocol MainViewModelInput {
    
    var input: MainViewModelInput { get }
    
    func viewDidLoad()
    
    func refresh()
}

protocol MainViewModelOutput {
    
    var weatherInfoViewModel: WeatherInfoHeaderViewModel { get }
    
}

public final class MainViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let addressRepository: AddressRepository
    private let weatherRepository: WeatherRepository
    private let fitftyRepository: FitftyRepository
    private let userManager: UserManager
    
    private var _location: CurrentValueSubject<(longitude: Double?, latitude: Double?), Never> = .init(
        (nil, nil)
    )
    private var _currentAverageTemp: CurrentValueSubject<Int, Never> = .init(0)

    public init(
        addressRepository: AddressRepository,
        weatherRepository: WeatherRepository,
        fitftyRepository: FitftyRepository,
        userManager: UserManager
    ) {
        self.addressRepository = addressRepository
        self.weatherRepository = weatherRepository
        self.fitftyRepository = fitftyRepository
        self.userManager = userManager
    }

}

extension MainViewModel: ViewModelType, MainViewModelOutput {
    
    public enum ViewModelState {
        case currentLocation(Address)
        case errorMessage(String)
        case isLoading(Bool)
        case sections([MainFeedSection])
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    var weatherInfoViewModel: WeatherInfoHeaderViewModel {
        .init(weatherRepository: weatherRepository, userManager: userManager)
    }
    
}

extension MainViewModel: MainViewModelInput {
    
    var input: MainViewModelInput { self }
    
    func viewDidLoad() {
        currentState.send(.isLoading(true))
        userManager.location
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] (longitude: Double, latitude: Double) in
                self?.update(longitude: longitude, latitude: latitude)
                self?._location.send((longitude, latitude))
        }).store(in: &cancellables)
        
        currentState.sink(receiveValue: { [weak self] state in
            switch state {
            case .currentLocation, .errorMessage, .sections:
                self?.currentState.send(.isLoading(false))
                
            default: return
            }
        }).store(in: &cancellables)
    }
    
    func refresh() {
        guard case .isLoading(let isLoading) = currentState.value, isLoading == false,
              let longitude = _location.value.longitude, let latitude = _location.value.latitude
        else {
            return
        }
        currentState.send(.isLoading(true))
        update(longitude: longitude, latitude: latitude)
    }
    
}

private extension MainViewModel {
    
    func update(longitude: Double, latitude: Double) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let address = try await self.getAddress(
                    longitude: longitude,
                    latitude: latitude
                )
                self.currentState.send(.currentLocation(address))
                self.currentState.send(.sections([
                    self.configureWeathers(
                        try await self.getWeathers(longitude: longitude, latitude: latitude)
                    ),
                    MainFeedSection(
                        sectionKind: .style, items: Array(0...8).map { _ in MainCellModel.styleTag(UUID()) }
                    ),
                    self.configureCodyList(
                        try await self.getCodyList()
                    )
                ]))
            } catch {
                Logger.debug(error: error, message: "사용자 위치 및 날씨 가져오기 실패")
                self.currentState.send(.errorMessage("현재 위치의 날씨 정보를 가져오는데 알 수 없는 에러가 발생했습니다."))
            }
        }
    }
    
    func getAddress(longitude: Double, latitude: Double) async throws -> Address {
        currentState.send(.isLoading(true))
        if let address = userManager.currentLocation {
            return address
        } else {
            let address = try await self.addressRepository.fetchAddress(
                longitude: longitude,
                latitude: latitude
            )
            userManager.updateCurrentLocation(address)
            return address
        }
    }
    
    func getWeathers(longitude: Double, latitude: Double) async throws -> [ShortTermForecast] {
        currentState.send(.isLoading(true))
        let shortTermForecast = try await weatherRepository.fetchShortTermForecast(
            longitude: longitude.description, latitude: latitude.description
        )
        let averageTemp =  try await weatherRepository.getTodayAverageTemp(
            longitude: longitude.description, latitude: latitude.description
        )
        _currentAverageTemp.send(averageTemp)
        return shortTermForecast
    }
    
    func getCodyList() async throws -> [CodyResponse] {
        currentState.send(.isLoading(true))
        let tag = WeatherTag(temp: _currentAverageTemp.value)
        let response = try await fitftyRepository.fetchCodyList(weather: tag)
        guard let codyList = response.data?.pictureDetailInfoList else {
            Logger.debug(error: FitftyAPIError.notFound(response.message), message: "코디 목록 조회 실패")
            return []
        }
        return codyList
    }
    
    func configureWeathers(_ weathers: [ShortTermForecast]) -> MainFeedSection {
        return MainFeedSection(
            sectionKind: .weather,
            items: weathers.map { MainCellModel.weather($0)}
        )
    }
    
    func configureCodyList(_ list: [CodyResponse]) -> MainFeedSection {
        return MainFeedSection(
            sectionKind: .cody,
            items: list.map { MainCellModel.cody($0)}
        )
    }
}
