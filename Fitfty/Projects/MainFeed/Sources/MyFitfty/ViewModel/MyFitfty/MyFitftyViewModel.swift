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

protocol MyFitftyViewModelInput {
    
    var input: MyFitftyViewModelInput { get }
    func viewDidLoad()
    func getPhAssetInfo(_ phAssetInfo: PHAssetInfo)
    func didTapTag(_ sectionKind: MyFitftySectionKind, index: Int)
    func editContent(text: String)
    
}

public final class MyFitftyViewModel {
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    public init() { }
    
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
        selectedPhAssetInfo = phAssetInfo
        currentState.send(.codyImage(phAssetInfo.image))
        currentState.send(.sections([
            MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
            MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
            MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
            MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
        ], true))
        currentState.send(.isEnabledUpload(checkIsEnabledUpload()))
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
    }
    
}
