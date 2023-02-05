//
//  AddressViewModel.swift
//  MainFeed
//
//  Created by Ari on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common
import Core

protocol AddressViewModelInput {
    
    var input: AddressViewModelInput { get }
    
    func search(text: String)
    
    func didTapAddress(_ address: Address)
    
    func didTapSelected()
}

public final class AddressViewModel {

    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    private let addressRespository: AddressRepository

    public init(addressRespository: AddressRepository = DefaultAddressRepository()) {
        self.addressRespository = addressRespository
    }

}

extension AddressViewModel: ViewModelType {
    public enum ViewModelState {
        case errorMessage(String)
        case isLoading(Bool)
        case sections([AddressSection])
        case weather(weather: WeatherNow, address: String)
        case isEmpty(Bool)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
}

extension AddressViewModel: AddressViewModelInput {
    
    var input: AddressViewModelInput { self }
    
    func search(text: String) {
        Task {
            do {
                let addressList = try await addressRespository.fetchAddressList(search: text)
                currentState.send(.isEmpty(addressList.isEmpty))
                currentState.send(.sections([
                    AddressSection(sectionKind: .address, items: addressList)
                ]))
            } catch {
                Logger.debug(error: error, message: "주소 검색 결과 가져오기 실패")
                self.currentState.send(.errorMessage("주소 검색 결과를 가져오다가 알 수 없는 에러가 발생했습니다."))
            }
        }
    }
    
    func didTapAddress(_ address: Address) {
        
    }
    
    func didTapSelected() {
        
    }
}
