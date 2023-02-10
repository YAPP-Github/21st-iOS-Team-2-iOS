//
//  MyFitftyViewModel.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import Combine
import UIKit
import Core

protocol MyFitftyViewModelInput {
    
    var input: MyFitftyViewModelInput { get }
    func viewDidLoad()
    func getPhAssetInfo(_ phAssetInfo: PHAssetInfo)
    func didTapTag(_ sectionKind: MyFitftySectionKind, index: Int)
    func editContent(text: String)
    
}

public final class MyFitftyViewModel {
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    private let weatherRepository: WeatherRepository
    private let addressRepository: AddressRepository
    private let userManager: UserManager
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var styleTagItems : [(styleTag: StyleTag, isSelected: Bool)] = [
        (.minimal, false),
        (.modern, false),
        (.casual, false),
        (.street, false),
        (.lovely, false),
        (.hip, false),
        (.luxury, false)
    ]
    
    private var weatherTagItems: [(weatherTag: WeatherTag, isSelected: Bool)] = [
        (.coldWaveWeather, false),
        (.coldWeather, false),
        (.chillyWeather, false),
        (.warmWeather, false),
        (.hotWeather, false)
    ]
    
    private var genderTagItems: [(gender: String, isSelected: Bool)] = [
        ("여성", true),
        ("남성", false)
    ]
    
    private let textViewPlaceHolder = "2200자 이내로 설명을 남길 수 있어요."
    private var contentText: String?
    private var selectedPhAssetInfo: PHAssetInfo?
    private var location: String?
    
    public init(
        weatherRepository: WeatherRepository,
        addressRepository: AddressRepository,
        userManager: UserManager
    ) {
        self.weatherRepository = weatherRepository
        self.addressRepository = addressRepository
        self.userManager = userManager
    }
    
}

extension MyFitftyViewModel {
    
    private func getStyleTagCellModels() -> [MyFitftyCellModel] {
        var cellModels: [MyFitftyCellModel] = []
        for index in 0..<styleTagItems.count {
            cellModels.append(MyFitftyCellModel.styleTag(styleTagItems[index].styleTag, styleTagItems[index].isSelected))
        }
        return cellModels
    }
    
    private func getWeatherTagCellModels() -> [MyFitftyCellModel] {
        var cellModels: [MyFitftyCellModel] = []
        for index in 0..<weatherTagItems.count {
            cellModels.append(MyFitftyCellModel.weatherTag(weatherTagItems[index].weatherTag, weatherTagItems[index].isSelected))
        }
        return cellModels
    }
    
    private func getGenderTagCellModels() -> [MyFitftyCellModel] {
        var cellModels: [MyFitftyCellModel] = []
        for index in 0..<genderTagItems.count {
            cellModels.append(MyFitftyCellModel.genderTag(genderTagItems[index].gender, genderTagItems[index].isSelected))
        }
        return cellModels
    }
    
    private func changeTag(_ sectionKind: MyFitftySectionKind, selectedIndex: Int?) {
        switch sectionKind {
        case .styleTag:
            if let selectedIndex = selectedIndex {
                styleTagItems[selectedIndex].isSelected = styleTagItems[selectedIndex].isSelected ? false : true
            }
            
        case .weatherTag:
            for index in 0..<weatherTagItems.count {
                weatherTagItems[index].isSelected = false
            }
            if let selectedIndex = selectedIndex {
                weatherTagItems[selectedIndex].isSelected = true
            }
            
        case .genderTag:
            for index in 0..<genderTagItems.count {
                genderTagItems[index].isSelected = genderTagItems[index].isSelected ? false : true
            }
        default:
            break
        }
    }
    
    private func checkIsEnabledUpload() -> Bool {
        if contentText != nil
            && contentText != textViewPlaceHolder
            && selectedPhAssetInfo != nil
            && styleTagItems.filter({ $0.isSelected == true }).count > 0
            && weatherTagItems.filter({ $0.isSelected == true }).count > 0 {
            return true
        } else {
            return false
        }
    }
    
    private func dateFormatYYMMDD(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.yyMMddDot.rawValue
        return dateFormatter.string(from: date)
    }
    
    private func getWeatherTagIndex(_ string: String) -> Int? {
        if string == WeatherTag.coldWaveWeather.koreanWeatherTag {
            return 0
        } else if string == WeatherTag.coldWeather.koreanWeatherTag {
            return 1
        } else if string == WeatherTag.chillyWeather.koreanWeatherTag {
            return 2
        } else if string == WeatherTag.warmWeather.koreanWeatherTag {
            return 3
        } else if string == WeatherTag.hotWeather.koreanWeatherTag {
            return 4
        } else {
            return nil
        }
    }
}

extension MyFitftyViewModel: MyFitftyViewModelInput {
    
    var input: MyFitftyViewModelInput { self }
    
    func viewDidLoad() {
        currentState.send(.sections([
            MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
            MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
            MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
            MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
        ], true))
    }
    
    func getPhAssetInfo(_ phAssetInfo: PHAssetInfo) {
        update(phAssetInfo: phAssetInfo)
        currentState.sink(receiveValue: { [weak self] state in
            switch state {
            case .errorMessage, .sections, .imageInfoMessage:
                self?.currentState.send(.isLoading(false))
                
            default: return
            }
        }).store(in: &cancellables)
        
    }
    
    func didTapTag(_ sectionKind: MyFitftySectionKind, index: Int) {
        changeTag(sectionKind, selectedIndex: index)
        currentState.send(.sections([
            MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
            MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
            MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
            MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
        ], false))
        currentState.send(.isEnabledUpload(checkIsEnabledUpload()))
    }
    
    func editContent(text: String) {
        contentText = text
        currentState.send(.content(text))
        currentState.send(.sections([
            MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
            MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
            MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
            MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
        ], false))
        currentState.send(.isEnabledUpload(checkIsEnabledUpload()))
    }
    
}

extension MyFitftyViewModel: ViewModelType {
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    public enum ViewModelState {
        case sections([MyFitftySection], Bool)
        case codyImage(UIImage)
        case content(String)
        case isEnabledUpload(Bool)
        case imageInfoMessage(String)
        case isLoading(Bool)
        case errorMessage(String)
    }
    
}

private extension MyFitftyViewModel {
    
    func update(phAssetInfo: PHAssetInfo) {
        selectedPhAssetInfo = phAssetInfo
        let date = phAssetInfo.date
        let longitude = phAssetInfo.longitude
        let latitude = phAssetInfo.latitude
        currentState.send(.codyImage(phAssetInfo.image))
        currentState.send(.isEnabledUpload(checkIsEnabledUpload()))
        currentState.send(.sections([
            MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
            MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
            MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
            MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
        ], true))
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                // 위치, 날짜 모두 있는 경우
                if let longitude = longitude,
                   let latitude = latitude,
                   let date = date {
                    let dailyWeather = try await self.getDailyWeather(date: date, longitude: longitude, latitude: latitude)
                    let address = try await self.getAddress(longitude: longitude, latitude: latitude)
                    self.location = address.fullName
                    print(address.fullName)
                    let imageInfoMessage = """
                    사진 찍은 날의 날씨 정보를 불러왔어요. \(dateFormatYYMMDD(date)) / 평균 \(dailyWeather.averageTemp)도
                    \(dailyWeather.averageTemp.koreanWeatherTag)에 입는 옷이 아니라면 고쳐주세요.
                    """
                    currentState.send(.imageInfoMessage(imageInfoMessage))
                    changeTag(.weatherTag, selectedIndex: getWeatherTagIndex(dailyWeather.averageTemp.koreanWeatherTag))
                } else {
                    let imageInfoMessage = """
                    사진에 등록된 날짜 · 위치 정보가 없어요.
                    직접 어떤 날씨에 입는 옷인지 선택해주세요.
                    """
                    currentState.send(.imageInfoMessage(imageInfoMessage))
                }
                currentState.send(.sections([
                    MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
                    MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
                    MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
                    MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
                ], true))
            } catch {
                Logger.debug(error: error, message: "사진 날씨정보 가져오기 실패")
                self.currentState.send(.errorMessage("사진의 날씨 정보를 가져오는데 알 수 없는 에러가 발생했습니다."))
            }
        }
    }
    
    func getDailyWeather(date: Date, longitude: Double, latitude: Double) async throws -> DailyWeather {
        currentState.send(.isLoading(true))
        print(longitude.description, latitude.description)
        let dailyWeather = try await self.weatherRepository.fetchDailyWeather(
            for: date,
            longitude: longitude.description,
            latitude: latitude.description
        )
        return dailyWeather
    }
    
    func getAddress(longitude: Double, latitude: Double) async throws -> Address {
        currentState.send(.isLoading(true))
        let address = try await self.addressRepository.fetchAddress(
            longitude: longitude,
            latitude: latitude
        )
        return address
    }
    
}
