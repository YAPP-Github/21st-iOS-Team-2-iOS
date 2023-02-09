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
            for index in 0..<styleTagItems.count {
                styleTagItems[index].isSelected = false
            }
            if let selectedIndex = selectedIndex {
                styleTagItems[selectedIndex].isSelected = true
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
        currentState.send(.codyImage(phAssetInfo.image))
        currentState.send(.sections([
            MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
            MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
            MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
            MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
        ], true))
    }
    
    func didTapTag(_ sectionKind: MyFitftySectionKind, index: Int) {
        changeTag(sectionKind, selectedIndex: index)
        currentState.send(.sections([
            MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
            MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
            MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
            MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
        ], false))
    }
    
    func editContent(text: String) {
        currentState.send(.content(text))
        currentState.send(.sections([
            MyFitftySection(sectionKind: .content, items: [MyFitftyCellModel.content(UUID())]),
            MyFitftySection(sectionKind: .weatherTag, items: getWeatherTagCellModels()),
            MyFitftySection(sectionKind: .genderTag, items: getGenderTagCellModels()),
            MyFitftySection(sectionKind: .styleTag, items: getStyleTagCellModels())
        ], false))
    }
    
}

extension MyFitftyViewModel: ViewModelType {
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    public enum ViewModelState {
        case sections([MyFitftySection], Bool)
        case codyImage(UIImage)
        case content(String)
    }
    
}
