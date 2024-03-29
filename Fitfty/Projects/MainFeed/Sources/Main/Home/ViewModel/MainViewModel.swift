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
    
    func reload()
    
    func didTapTag(_ tag: Tag)
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
    private var _currentStyles: CurrentValueSubject<[StyleTag], Never> = .init([])
    private var _currentGender: CurrentValueSubject<Gender?, Never> = .init(nil)
    
    private var _weathers: [MainCellModel] = []

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
        case showWelcomeSheet
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    var weatherInfoViewModel: WeatherInfoHeaderViewModel {
        .init(weatherRepository: weatherRepository, userManager: userManager)
    }
    
}

extension MainViewModel: MainViewModelInput {
    
    var input: MainViewModelInput { self }
    
    func viewDidLoad() {
        userManager.location
            .compactMap { $0 }
            .removeDuplicates(by: { $0.latitude == $1.latitude && $0.longitude == $1.longitude })
            .sink(receiveValue: { [weak self] (longitude: Double, latitude: Double) in
                self?.weatherRepository.reset()
                self?.currentState.send(.isLoading(true))
                self?.setUp(longitude: longitude, latitude: latitude)
                self?._location.send((longitude, latitude))
            }).store(in: &cancellables)
        
        currentState.sink(receiveValue: { [weak self] state in
            switch state {
            case .currentLocation, .errorMessage, .sections:
                self?.currentState.send(.isLoading(false))
                
            default: return
            }
        }).store(in: &cancellables)
        
        if userManager.hasCompletedWelcomePage == false {
            currentState.send(.showWelcomeSheet)
        }
    }
    
    func refresh() {
        guard case .isLoading(let isLoading) = currentState.value, isLoading == false,
              let longitude = _location.value.longitude, let latitude = _location.value.latitude
        else {
            return
        }
        update(longitude: longitude, latitude: latitude)
        LocationManager.shared.requestLocation()
    }
    
    func reload() {
        guard case .isLoading(let isLoading) = currentState.value, isLoading == false,
              let longitude = _location.value.longitude, let latitude = _location.value.latitude
        else {
            return
        }
        currentState.send(.isLoading(true))
        update(longitude: longitude, latitude: latitude)
        LocationManager.shared.requestLocation()
    }
    
    func didTapTag(_ tag: Tag) {
        updateTags(tag)
        Task {
            do {
                let styles = _currentStyles.value
                let gender = _currentGender.value ?? .female
                let codyList = try await getCodyList(gender: gender, styles: styles)
                currentState.send(.sections([
                    MainFeedSection(sectionKind: .weather, items: _weathers),
                    configureTags(styles: styles, gender: gender),
                    configureCodyList(codyList)
                ]))
            } catch {
                Logger.debug(error: error, message: MainFeedError.codyLoadFailed.errorDescription ?? "")
                currentState.send(.errorMessage(MainFeedError.codyLoadFailed.userGuideErrorMessage))
            }
        }
    }
    
}

private extension MainViewModel {
    
    func setUp(longitude: Double, latitude: Double) {
        Task {
            do {
                let address = try await getAddress(longitude: longitude, latitude: latitude)
                let tags = await getTags()
                let gender = tags.0
                let styles = tags.1
                let weathers = try await getWeathers(longitude: longitude, latitude: latitude)
                let codyList = try await getCodyList(gender: gender, styles: styles)
                currentState.send(.currentLocation(address))
                currentState.send(.sections([
                    configureWeathers(weathers),
                    configureTags(styles: styles, gender: gender),
                    configureCodyList(codyList)
                ]))
            } catch {
                Logger.debug(error: error, message: MainFeedError.setUpFailed.errorDescription ?? "")
                currentState.send(.errorMessage(MainFeedError.setUpFailed.userGuideErrorMessage))
            }
        }
    }
    
    func update(longitude: Double, latitude: Double) {
        Task {
            do {
                let styles = _currentStyles.value
                let gender = _currentGender.value ?? .female
                let codyList = try await getCodyList(gender: gender, styles: styles)
                let weathers = try await getWeathers(longitude: longitude, latitude: latitude)
                currentState.send(.sections([
                    configureWeathers(weathers),
                    configureTags(styles: styles, gender: gender),
                    configureCodyList(codyList)
                ]))
            } catch {
                Logger.debug(error: error, message: MainFeedError.updateFailed.errorDescription ?? "")
                currentState.send(.errorMessage(MainFeedError.updateFailed.userGuideErrorMessage))
            }
        }
    }
    
    func getAddress(longitude: Double, latitude: Double) async throws -> Address {
        if let address = userManager.currentLocation {
            return address
        } else {
            let address = try await self.addressRepository.fetchAddress(
                longitude: longitude,
                latitude: latitude
            )
            return address
        }
    }
    
    func getWeathers(longitude: Double, latitude: Double) async throws -> [ShortTermForecast] {
        let shortTermForecast = try await weatherRepository.fetchShortTermForecast(
            longitude: longitude.description, latitude: latitude.description
        )
        let averageTemp =  try await weatherRepository.getTodayAverageTemp(
            longitude: longitude.description, latitude: latitude.description
        )
        _currentAverageTemp.send(averageTemp)
        return shortTermForecast
    }
    
    func getCodyList(gender: Gender?, styles: [StyleTag]?) async throws -> [(CodyResponse, ProfileType)] {
        let tag = WeatherTag(temp: _currentAverageTemp.value)
        let response = try await fitftyRepository.fetchCodyList(weather: tag, gender: gender, styles: styles)
        guard let codyList = response.data?.pictureDetailInfoList else {
            Logger.debug(error: FitftyAPIError.notFound(response.message), message: MainFeedError.codyLoadFailed.errorDescription ?? "")
            return []
        }
        if userManager.getCurrentGuestState() {
            return codyList
                .map { ($0, .userProfile) }
            
        } else {
            let userPrivacy = try await self.getUserPrivacy()
            if userPrivacy.data?.role == "ROLE_ADMIN" {
                userManager.updateAdminState(true)
            } else {
                userManager.updateAdminState(false)
            }
            let myUserToken = userPrivacy.data?.userToken
            return codyList
                .map { ($0, $0.userToken == myUserToken ? .myProfile : .userProfile) }
        }
    }
    
    func getUserPrivacy() async throws -> UserPrivacyResponse {
        return try await fitftyRepository.getUserPrivacy()
    }
    
    func getTags() async -> (Gender, [StyleTag]) {
        guard _currentGender.value == nil else {
            return (_currentGender.value ?? .female, _currentStyles.value)
        }
        return await withCheckedContinuation { continuation in
            Task {
                do {
                    let response = try await fitftyRepository.fetchMyInfo()
                    if let data = response.data {
                        continuation.resume(returning: (data.gender, data.style))
                        _currentStyles.send(data.style)
                        _currentGender.send(data.gender)
                        userManager.updateGender(data.gender)
                        userManager.updateGuestState(false)
                    } else {
                        Logger.debug(error: MainFeedError.tagLoadFailed, message: MainFeedError.tagLoadFailed.errorDescription ?? "")
                        continuation.resume(returning: (.female, []))
                    }
                } catch {
                    Logger.debug(error: error, message: "태그 설정 조회 실패")
                    continuation.resume(returning: (.female, []))
                }
            }
        }
    }
    
    func configureWeathers(_ weathers: [ShortTermForecast]) -> MainFeedSection {
        let items = weathers.map { MainCellModel.weather($0)}
        _weathers = items
        return MainFeedSection(
            sectionKind: .weather,
            items: items
        )
    }
    
    func configureCodyList(_ list: [(CodyResponse, ProfileType)]) -> MainFeedSection {
        return MainFeedSection(
            sectionKind: .cody,
            items: list.map { MainCellModel.cody($0.0, $0.1) }
        )
    }
    
    func configureTags(styles: [StyleTag], gender: Gender) -> MainFeedSection {
        let defaultData: [String] = ["filter"] + Gender.allCases.map { $0.localized} + StyleTag.allCases.map { $0.styleTagKoreanString }
        let userData: [String] = [gender.localized] + styles.map { $0.styleTagKoreanString }
        let tags: [MainCellModel] = defaultData.map { MainCellModel.styleTag(Tag(title: $0, isSelected: userData.contains($0))) }
        return MainFeedSection(
            sectionKind: .style,
            items: tags
        )
    }
    
    func updateTags(_ tag: Tag) {
        if tag.isGender {
            _currentGender.send(Gender(tag.title))
        } else {
            var styles = _currentStyles.value
            let style = StyleTag(tag.title) ?? .minimal
            if let index = styles.firstIndex(of: style) {
                styles.remove(at: index)
            } else {
                styles.append(style)
            }
            _currentStyles.send(styles)
        }
    }
    
}
