//
//  UserManager.swift
//  Core
//
//  Created by Ari on 2023/02/03.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine

public protocol UserManager {
    var isNewUser: Bool { get }
    var currentLocation: Address? { get }
    var location: AnyPublisher<(longitude: Double, latitude: Double)?, Never> { get }
    
    func updateUserState(_ state: Bool)
    func updateCurrentLocation(_ address: Address)
}

public final class DefaultUserManager {
    
    public static let shared = DefaultUserManager()
    
    private let localStorage: LocalStorageService
    
    private var _location: CurrentValueSubject<(longitude: Double, latitude: Double)?, Never> = .init(nil)
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private init(localStorage: LocalStorageService = UserDefaults.standard) {
        self.localStorage = localStorage

        LocationManager.shared.currentLocation()
            .compactMap { $0 }
            .map { ($0.coordinate.longitude, $0.coordinate.latitude )}
            .sink(receiveValue: { [weak self] (longitude: Double, latitude: Double) in
                self?._location.send((longitude, latitude))
            }).store(in: &cancellables)
    }
}

extension DefaultUserManager: UserManager {
    
    public var isNewUser: Bool {
        localStorage.read(key: .isNewUser) as? Bool ?? true
    }
    
    public var currentLocation: Address? {
        let address = localStorage.read(key: .currentLocation) as? [String: Any] ?? [:]
        return Address(address)
    }
    
    public var location: AnyPublisher<(longitude: Double, latitude: Double)?, Never> { _location.eraseToAnyPublisher() }
    
    public func updateUserState(_ state: Bool) {
        localStorage.write(key: .isNewUser, value: state)
    }
    
    public func updateCurrentLocation(_ address: Address) {
        guard let addressDictionary = try? address.asDictionary() else {
            return
        }
        localStorage.write(key: .currentLocation, value: addressDictionary)
        _location.send(
            (Double(address.x) ?? 127.016702905651, Double(address.y) ?? 37.5893588153919)
        )
    }
    
}
