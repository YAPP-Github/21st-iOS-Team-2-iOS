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
    func didTapUpload()
    
}

public final class MyFitftyViewModel {
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    private let weatherRepository: WeatherRepository
    private let addressRepository: AddressRepository
    private let myFitftyType: MyFitftyType
    private let userManager: UserManager
    private let boardToken: String?
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
        (.freezing, false),
        (.cold, false),
        (.chilly, false),
        (.warm, false),
        (.hot, false)
    ]
    
    private var genderTagItems: [(gender: String, isSelected: Bool)] = [
        ("여성", true),
        ("남성", false)
    ]
    
    private let textViewPlaceHolder = "내 코디에 대한 설명을 남겨보세요."
    private var contentText: String?
    private var selectedPhAssetInfo: PHAssetInfo?
    private var location: String?
    private var temperature: String?
    private var cloudType: String?
    private var photoTakenTime: String?
    private var filepath: String?
    
    public init(
        weatherRepository: WeatherRepository,
        addressRepository: AddressRepository,
        userManager: UserManager,
        myFitftyType: MyFitftyType,
        boardToken: String?
    ) {
        self.weatherRepository = weatherRepository
        self.addressRepository = addressRepository
        self.userManager = userManager
        self.boardToken = boardToken
        self.myFitftyType = myFitftyType
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
                genderTagItems[index].isSelected = false
            }
            if let selectedIndex = selectedIndex {
                genderTagItems[selectedIndex].isSelected = true
            }
            
        default:
            break
        }
    }
    
    private func checkIsEnabledUpload() -> Bool {
        switch myFitftyType {
        case .uploadMyFitfty:
            if  selectedPhAssetInfo != nil
                && styleTagItems.filter({ $0.isSelected == true }).count > 0
                && weatherTagItems.filter({ $0.isSelected == true }).count > 0 {
                return true
            } else {
                return false
            }
        case .modifyMyFitfty:
            if  styleTagItems.filter({ $0.isSelected == true }).count > 0
                && weatherTagItems.filter({ $0.isSelected == true }).count > 0 {
                return true
            } else {
                return false
            }
        }
    }
    
    private func dateFormatYYMMDD(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.yyMMddDot.rawValue
        return dateFormatter.string(from: date)
    }
    
    private func getWeatherTagIndex(_ string: String) -> Int? {
        if string == WeatherTag.freezing.koreanWeatherTag || string == WeatherTag.freezing.englishWeatherTag {
            return 0
        } else if string == WeatherTag.cold.koreanWeatherTag || string == WeatherTag.cold.englishWeatherTag {
            return 1
        } else if string == WeatherTag.chilly.koreanWeatherTag || string == WeatherTag.chilly.englishWeatherTag {
            return 2
        } else if string == WeatherTag.warm.koreanWeatherTag || string == WeatherTag.warm.englishWeatherTag {
            return 3
        } else if string == WeatherTag.hot.koreanWeatherTag || string == WeatherTag.hot.englishWeatherTag {
            return 4
        } else {
            return nil
        }
    }
    
    private func getStyleTagIndex(_ string: String) -> Int? {
        if string == StyleTag.minimal.styleTagEnglishString {
            return 0
        } else if string == StyleTag.modern.styleTagEnglishString {
            return 1
        } else if string == StyleTag.casual.styleTagEnglishString {
            return 2
        } else if string == StyleTag.street.styleTagEnglishString {
            return 3
        } else if string == StyleTag.lovely.styleTagEnglishString {
            return 4
        } else if string == StyleTag.hip.styleTagEnglishString {
            return 5
        } else if string == StyleTag.luxury.styleTagEnglishString {
            return 6
        } else {
            return nil
        }
    }
    
    private func getWeaherTagString() -> String? {
        let weatherTag = weatherTagItems.filter { $0.isSelected==true }.first?.weatherTag.englishWeatherTag
        guard let weatherTag = weatherTag else {
            return nil
        }
        return weatherTag
    }
    
    private func getTapGroup() -> TagGroup? {
        guard let weatherTag = getWeaherTagString() else {
            return nil
        }
        let genderTag = genderTagItems[0].isSelected ? "FEMALE" : "MALE"
        let styleTag = styleTagItems.filter { $0.isSelected==true }.map { $0.styleTag.styleTagEnglishString }
        return TagGroup(weather: weatherTag, style: styleTag, gender: genderTag)
    }
    
}

extension MyFitftyViewModel: MyFitftyViewModelInput {
    
    var input: MyFitftyViewModelInput { self }
    
    func viewDidLoad() {
        switch myFitftyType {
        case .uploadMyFitfty:
            currentState.send(.sections([
                MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
                MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
                MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
                MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
            ], true))
        case .modifyMyFitfty:
            Task { [weak self] in
                do {
                    currentState.send(.isLoading(true))
                    guard let self = self else {
                        return
                    }
                    guard let boardToken = boardToken else {
                        return
                    }
                    let response = try await self.getPost(boardToken: boardToken)
                    if response.result == "SUCCESS" {
                        guard let data = response.data else {
                            return
                        }
                        contentText = data.content
                        filepath = data.filePath
                        if let temperature = data.temperature {
                            self.temperature = String(temperature)
                        }
                        cloudType = data.cloudType
                        photoTakenTime = data.photoTakenTime
                        location = data.location
                        
                        currentState.send(.codyFilepath(data.filePath))
                        currentState.send(.content(data.content ?? ""))
                        
                        let weaterTagIndex = getWeatherTagIndex(data.tagGroupInfo.weather)
                        changeTag(.weatherTag, selectedIndex: weaterTagIndex)
                        
                        let genderTagIndex = data.tagGroupInfo.gender == "FEMALE" ? 0 : 1
                        changeTag(.genderTag, selectedIndex: genderTagIndex)
                        
                        for styleTagString in data.tagGroupInfo.style {
                            let styleTagIndex = getStyleTagIndex(styleTagString)
                            changeTag(.styleTag, selectedIndex: styleTagIndex)
                        }
                        
                        if let temperature = data.temperature,
                           let weather = data.tagGroupInfo.weather.stringToWeatherTag?.koreanWeatherTag,
                           let photoTakenTime = data.photoTakenTime {
                            let imageInfoMessage = """
                            사진 찍은 날의 날씨 정보를 불러왔어요. \(photoTakenTime.yymmddFromCreatedDate) / 평균 \(temperature)도
                            \(weather)에 입는 옷이 아니라면 고쳐주세요.
                            """
                            currentState.send(.imageInfoMessage(imageInfoMessage))
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
                        currentState.send(.isLoading(false))
                    } else {
                        currentState.send(.isLoading(false))
                        currentState.send(.errorMessage("프로필 조회에 알 수 없는 에러가 발생했습니다."))
                    }
                } catch {
                    Logger.debug(error: error, message: "작성했던 게시글 조회 실패")
                    currentState.send(.isLoading(false))
                    currentState.send(.errorMessage("작성했던 게시글 조회에 알 수 없는 에러가 발생했습니다."))
                }
            }
        }
        
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
    
    func didTapUpload() {
        upload()
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
        case completed(Bool)
        case codyFilepath(String)
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
                    
                    let imageInfoMessage = """
                    사진 찍은 날의 날씨 정보를 불러왔어요. \(dateFormatYYMMDD(date)) / 평균 \(dailyWeather.averageTemp)도
                    \(dailyWeather.averageTemp.koreanWeatherTag)에 입는 옷이 아니라면 고쳐주세요.
                    """
                    currentState.send(.imageInfoMessage(imageInfoMessage))
                    changeTag(.weatherTag, selectedIndex: getWeatherTagIndex(dailyWeather.averageTemp.koreanWeatherTag))
                    self.location = address.fullName
                    self.photoTakenTime = date.ISOStringFromDate(date: date)
                    self.temperature = dailyWeather.averageTemp
                    self.cloudType = dailyWeather.forecast.englishForecast
                } else {
                    let imageInfoMessage = """
                    사진에 등록된 날짜 · 위치 정보가 없어요.
                    직접 어떤 날씨에 입는 옷인지 선택해주세요.
                    """
                    currentState.send(.imageInfoMessage(imageInfoMessage))
                    changeTag(.weatherTag, selectedIndex: nil)
                    
                    // 위치만 있는 경우
                    if let latitude = latitude,
                       let longitude = longitude {
                        let address = try await self.getAddress(longitude: longitude, latitude: latitude)
                        self.location = address.fullName
                    }
                    
                    // 날짜만 있는 경우
                    if let date = date {
                        self.photoTakenTime = date.ISOStringFromDate(date: date)
                    }
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
    
    func upload() {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.currentState.send(.isLoading(true))
                if let tagGroup = getTapGroup() {
                    switch myFitftyType {
                    case .uploadMyFitfty:
                        guard let selectedPhAssetInfo = selectedPhAssetInfo else {
                            return
                        }
                        let data = selectedPhAssetInfo.image.jpegData(compressionQuality: 0.5) ?? Data()
                        guard let weatherTag = self.getWeaherTagString() else {
                            return
                        }
                        let filename =
                        (self.genderTagItems[0].isSelected ? "female/" : "male/") + weatherTag + "_" + Date().currentfullDate
                        let filepath = try await AmplifyManager.shared.uploadImage(data: data, fileName: filename)
                        
                        let request = MyFitftyRequest(
                            filePath: filepath.absoluteString,
                            content: (self.contentText == self.textViewPlaceHolder ? "" : self.contentText) ?? "",
                            temperature: self.temperature,
                            location: self.location,
                            cloudType: cloudType,
                            photoTakenTime: photoTakenTime,
                            tagGroup: tagGroup
                        )
                        
                        let response = try await postMyFitfty(request)
                        if response.result == "SUCCESS" {
                            self.currentState.send(.completed(true))
                        } else {
                            self.currentState.send(.completed(false))
                            self.currentState.send(.errorMessage("핏프티 등록에 알 수 없는 에러가 발생했습니다."))
                        }

                    case .modifyMyFitfty:
                        guard let filepath = filepath,
                              let boardToken = boardToken else {
                            return
                        }
                        let request = MyFitftyRequest(
                            filePath: filepath,
                            content: (self.contentText == self.textViewPlaceHolder ? "" : self.contentText) ?? "",
                            temperature: self.temperature,
                            location: self.location,
                            cloudType: self.cloudType,
                            photoTakenTime: self.photoTakenTime,
                            tagGroup: tagGroup
                        )
                        print(request)
                        let response = try await putPost(request: request, boardToken: boardToken)
                        if response.result == "SUCCESS" {
                            self.currentState.send(.completed(true))
                        } else {
                            print(response)
                            self.currentState.send(.completed(false))
                            self.currentState.send(.errorMessage("핏프티 수정에 알 수 없는 에러가 발생했습니다."))
                        }
                    }
                } else {
                    self.currentState.send(.completed(false))
                    self.currentState.send(.errorMessage("핏프티 등록에 알 수 없는 에러가 발생했습니다."))
                }
                self.currentState.send(.isLoading(false))
            } catch {
                Logger.debug(error: error, message: "핏프티 등록 실패")
                self.currentState.send(.isLoading(false))
                self.currentState.send(.errorMessage("핏프티 등록에 알 수 없는 에러가 발생했습니다."))
            }
        }
    }
    
    func getDailyWeather(date: Date, longitude: Double, latitude: Double) async throws -> DailyWeather {
        currentState.send(.isLoading(true))
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
    
    func postMyFitfty(_ request: MyFitftyRequest) async throws -> UploadMyFitftyResponse {
        let response = try await FitftyAPI.request(
            target: .postMyFitfty(parameters: request.asDictionary()),
            dataType: UploadMyFitftyResponse.self
        )
        return response
    }
    
    func getPost(boardToken: String) async throws -> PostResponse {
        let response = try await FitftyAPI.request(
            target: .getPost(boardToken: boardToken),
            dataType: PostResponse.self
        )
        return response
    }
    
    func putPost(request: MyFitftyRequest, boardToken: String) async throws -> ModifyMyFitftyResponse {
        let response = try await FitftyAPI.request(
            target: .putPost(parameters: request.asDictionary(), boardToken: boardToken),
            dataType: ModifyMyFitftyResponse.self
        )
        return response
    }
    
}
