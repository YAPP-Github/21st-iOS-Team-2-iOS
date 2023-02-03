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
import CoreLocation

enum MainViewSection {
    case weather
    case style
    case cody
    
    init?(index: Int) {
        switch index {
        case 0: self = .weather
        case 1: self = .style
        case 2: self = .cody
        default: return nil
        }
    }
}

protocol MainViewModelInput {
    
    var input: MainViewModelInput { get }
    
    func viewDidLoad()
    
    func viewWillAppear()
    
    func viewDidAppear()
}

public final class MainViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let addressRepository: AddressRepository
    private let userManager: UserManager
    
    private var _location: CurrentValueSubject<CLLocation?, Never> = .init(nil)

    public init(
        addressRepository: AddressRepository = DefaultAddressRepository(),
        userManager: UserManager = DefaultUserManager()
    ) {
        self.addressRepository = addressRepository
        self.userManager = userManager
    }

}

extension MainViewModel: ViewModelType {
    public enum ViewModelState {
        case currentLocation(Address)
        case errorMessage(String)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
}

extension MainViewModel: MainViewModelInput {
    
    var input: MainViewModelInput { self }
    
    func viewDidLoad() {
        LocationManager.shared.currentLocation()
            .sink(receiveValue: { [weak self] location in
                Task { [weak self] in
                    guard let self = self else {
                        return
                    }
                    do {
                        let address = try await self.getAddress(location: location)
                        self.currentState.send(.currentLocation(address))
                        self.userManager.updateCurrentLocation(address)
                    } catch {
                        Logger.debug(error: error, message: "사용자 위치 가져오기 실패")
                        self.currentState.send(.errorMessage("현재 위치를 가져오는데 알 수 없는 에러가 발생했습니다."))
                    }
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
    
    func getAddress(location: CLLocation) async throws -> Address {
        if let address = userManager.currentLocation {
            return address
        } else {
            let address = try await self.addressRepository.fetchAddress(
                longitude: location.coordinate.longitude,
                latitude: location.coordinate.latitude
            )
            userManager.updateCurrentLocation(address)
            return address
        }
    }
}
