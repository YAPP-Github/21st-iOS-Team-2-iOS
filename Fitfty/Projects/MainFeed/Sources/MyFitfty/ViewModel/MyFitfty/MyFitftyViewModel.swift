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
    
}

public final class MyFitftyViewModel {
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    public init() { }
}

extension MyFitftyViewModel: MyFitftyViewModelInput {
    
    var input: MyFitftyViewModelInput { self }
    
    func viewDidLoad() {
        currentState.send(.sections([
            MyFitftySection(sectionKind: .content, items: [UUID()]),
            MyFitftySection(sectionKind: .weatherTag, items: Array(0..<5).map { _ in UUID() }),
            MyFitftySection(sectionKind: .styleTag, items: Array(0..<7).map { _ in UUID() })
        ]))
    }
    
    func getPhAssetInfo(_ phAssetInfo: PHAssetInfo) {
        currentState.send(.reload(phAssetInfo.image))
        currentState.send(.sections([
                MyFitftySection(sectionKind: .content, items: [UUID()]),
                MyFitftySection(sectionKind: .weatherTag, items: Array(0..<5).map { _ in UUID() }),
                MyFitftySection(sectionKind: .styleTag, items: Array(0..<7).map { _ in UUID() })
        ]))
    }
    
}

extension MyFitftyViewModel: ViewModelType {
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    public enum ViewModelState {
        case sections([MyFitftySection])
        case reload(UIImage)
    }

}
