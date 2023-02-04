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
    
    func viewWillAppear()
    
    func viewDidAppear()
}

protocol MainViewModelOutput {
    
    var weatherInfoViewModel: WeatherInfoHeaderViewModel { get }
    
}

public final class MainViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let addressRepository: AddressRepository
    private let weatherRepository: WeatherRepository
    private let userManager: UserManager
    
    private var _location: CurrentValueSubject<(longitude: Double?, latitude: Double?), Never> = .init(
        (nil, nil)
    )

    public init(
        addressRepository: AddressRepository = DefaultAddressRepository(),
        weatherRepository: WeatherRepository = DefaultWeatherRepository(),
        userManager: UserManager = DefaultUserManager()
    ) {
        self.addressRepository = addressRepository
        self.weatherRepository = weatherRepository
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
    
    var weatherInfoViewModel: WeatherInfoHeaderViewModel { .init(weatherRepository: weatherRepository) }
    
}

extension MainViewModel: MainViewModelInput {
    
    var input: MainViewModelInput { self }
    
    func viewDidLoad() {
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
                        let address = try await self.getAddress(
                            longitude: longitude,
                            latitude: latitude
                        )
                        self.currentState.send(.currentLocation(address))
                        self.userManager.updateCurrentLocation(address)
                        self.currentState.send(.sections([
                            self.configureWeathers(
                                try await self.getWeathers(longitude: longitude, latitude: latitude)
                            ),
                            MainFeedSection(
                                sectionKind: .style, items: Array(0...6).map { _ in MainCellModel.styleTag(UUID()) }
                            ),
                            MainFeedSection(
                                sectionKind: .cody, items: Array(0...10).map { _ in MainCellModel.cody(UUID()) }
                            )
                        ]))
                    } catch {
                        Logger.debug(error: error, message: "사용자 위치 가져오기 실패")
                        self.currentState.send(.errorMessage("현재 위치를 가져오는데 알 수 없는 에러가 발생했습니다."))
                    }
                }
        }).store(in: &cancellables)
        
        currentState.sink(receiveValue: { [weak self] state in
            switch state {
            case .currentLocation, .errorMessage, .sections:
                self?.currentState.send(.isLoading(false))
                
            default: return
            }
        }).store(in: &cancellables)
    }
    
    func viewWillAppear() {
        print(#function)
    }
    
    func viewDidAppear() {
        print(#function)
    }
    
}

private extension MainViewModel {
    
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
        return try await weatherRepository.fetchShortTermForecast(
            longitude: longitude.description, latitude: latitude.description
        )
    }
    
    func configureWeathers(_ weathers: [ShortTermForecast]) -> MainFeedSection {
        return MainFeedSection(
            sectionKind: .weather,
            items: weathers.map { MainCellModel.weather($0)}
        )
    }
}
