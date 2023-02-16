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
    private var myUserToken: String?
    private var isGuest: Bool {
           userManager.getCurrentGuestState()
    }

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
            .sink(receiveValue: { [weak self] (longitude: Double, latitude: Double) in
                self?.currentState.send(.isLoading(true))
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
        currentState.send(.isLoading(true))
        update(longitude: longitude, latitude: latitude)
    }
    
    func didTapTag(_ tag: Tag) {
        updateTags(tag)
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let styles = self._currentStyles.value
                let gender = self._currentGender.value ?? .female
                let codyList = try await self.getCodyList(gender: gender, styles: styles)
                let profileTypes: [ProfileType]
                var list: [(CodyResponse, ProfileType)] = []
                
                if self.isGuest {
                    profileTypes = Array(repeating: .userProfile, count: codyList.count)
                    for i in 0..<codyList.count {
                        list.append((codyList[i], profileTypes[i]))
                    }
                } else {
                    let userPrivacy = try await self.getUserPrivacy()
                    self.myUserToken = userPrivacy.data?.userToken
                    
                    for i in 0..<codyList.count {
                        list.append((codyList[i], codyList[i].userToken == self.myUserToken ? .myProfile : .userProfile))
                    }
                    
                }
                currentState.send(.sections([
                    MainFeedSection(sectionKind: .weather, items: self._weathers),
                    self.configureTags(styles: styles, gender: gender),
                    self.configureCodyList(list)
                ]))
            } catch {
                Logger.debug(error: error, message: "코디 목록 가져오기 실패")
                self.currentState.send(.errorMessage("코디 목록을 업데이트 하는데 알 수 없는 에러가 발생하여 실패하였습니다."))
            }
        }
    }
    
}

private extension MainViewModel {
    
    func update(longitude: Double, latitude: Double) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let address = try await self.getAddress(longitude: longitude, latitude: latitude)
                let tags = await self.getTags()
                let gender = tags.0
                let styles = tags.1
                let weathers = try await self.getWeathers(longitude: longitude, latitude: latitude)
                let codyList = try await self.getCodyList(gender: gender, styles: styles)
                let profileTypes: [ProfileType]
                var list: [(CodyResponse, ProfileType)] = []
                
                if self.isGuest {
                    profileTypes = Array(repeating: .userProfile, count: codyList.count)
                    for i in 0..<codyList.count {
                        list.append((codyList[i], profileTypes[i]))
                    }
                } else {
                    let userPrivacy = try await self.getUserPrivacy()
                    self.myUserToken = userPrivacy.data?.userToken
                    for i in 0..<codyList.count {
                        list.append((codyList[i], codyList[i].userToken == self.myUserToken ? .myProfile : .userProfile))
                    }
                }
                self.currentState.send(.currentLocation(address))
                self.currentState.send(.sections([
                    self.configureWeathers(weathers),
                    self.configureTags(styles: styles, gender: gender),
                    self.configureCodyList(list)
                ]))
            
            } catch {
                Logger.debug(error: error, message: "사용자 위치 및 날씨 가져오기 실패")
                self.currentState.send(.errorMessage("현재 위치의 날씨 정보를 가져오는데 알 수 없는 에러가 발생했습니다."))
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
    
    func getCodyList(gender: Gender?, styles: [StyleTag]?) async throws -> [CodyResponse] {
        let tag = WeatherTag(temp: _currentAverageTemp.value)
        let response = try await fitftyRepository.fetchCodyList(weather: tag, gender: gender, styles: styles)
        guard let codyList = response.data?.pictureDetailInfoList else {
            Logger.debug(error: FitftyAPIError.notFound(response.message), message: "코디 목록 조회 실패")
            return []
        }
        return codyList
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
                        Logger.debug(error: ViewModelError.failure(
                            errorCode: response.errorCode ?? "", message: response.message ?? ""
                        ), message: "태그 설정 조회 실패")
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
