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
    var hasCompletedWelcomePage: Bool { get }
    
    var location: AnyPublisher<(longitude: Double, latitude: Double)?, Never> { get }
    var gender: Gender? { get }
    var isGuest: AnyPublisher<Bool, Never> { get }
   
    func updateUserState(_ state: Bool)
    func updateCurrentLocation(_ address: Address)
    func updateGender(_ gender: Gender)
    func updateGuestState(_ isGuest: Bool)
    func updateCompletedWelcomePage()
    func getCurrentGuestState() -> Bool
   
}

public final class DefaultUserManager {
    
    public static let shared = DefaultUserManager(localStorage: UserDefaults.standard)
    
    private let localStorage: LocalStorageService
    
    private var _location: CurrentValueSubject<(longitude: Double, latitude: Double)?, Never> = .init(nil)
    private var _gender: Gender?
    private var _guestState: CurrentValueSubject<Bool, Never> = .init(true)
   
    private var cancellables: Set<AnyCancellable> = .init()
    
    private init(localStorage: LocalStorageService) {
        self.localStorage = localStorage
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
    
    public var hasCompletedWelcomePage: Bool {
        localStorage.read(key: .hasCompletedWelcomePage) as? Bool ?? false
    }
    
    public var location: AnyPublisher<(longitude: Double, latitude: Double)?, Never> { _location.eraseToAnyPublisher() }
    public var gender: Gender? { _gender }
    public var isGuest: AnyPublisher<Bool, Never> { _guestState.eraseToAnyPublisher() }
    
    public func updateUserState(_ state: Bool) {
        localStorage.write(key: .isNewUser, value: state)
    }
    
    public func updateCurrentLocation(_ address: Address) {
        guard let addressDictionary = try? address.asDictionary() else {
            return
        }
        localStorage.write(key: .currentLocation, value: addressDictionary)
        _location.send(
            (
                Double(address.x) ?? LocationManager.Constant.defaultLongitude,
                Double(address.y) ?? LocationManager.Constant.defaultLatitude
            )
        )
    }
    
    public func updateGender(_ gender: Gender) {
        _gender = gender
    }
    
    public func updateGuestState(_ isGuest: Bool) {
        _guestState.send(isGuest)
    }
    
    public func updateCompletedWelcomePage() {
        localStorage.write(key: .hasCompletedWelcomePage, value: true)
    }
    
    public func getCurrentGuestState() -> Bool {
        return _guestState.value
    }
    
    public func fetchCurrentLocation() {
        if let location =  localStorage.read(key: .currentLocation) as? [String: Any] {
            let x = Double(
                location["x"] as? String ?? LocationManager.Constant.defaultLongitude.description
            ) ?? LocationManager.Constant.defaultLongitude
            let y = Double(
                location["y"] as? String ?? LocationManager.Constant.defaultLatitude.description
            ) ?? LocationManager.Constant.defaultLatitude
            _location.send((x, y))
        } else {
            LocationManager.shared.currentLocation()
                .compactMap { $0 }
                .map { ($0.coordinate.longitude, $0.coordinate.latitude )}
                .sink(receiveValue: { [weak self] (longitude: Double, latitude: Double) in
                    self?._location.send((longitude, latitude))
                }).store(in: &cancellables)
        }
        guard let identifier = UserDefaults.standard.read(key: .userIdentifier) as? String,
              let account = UserDefaults.standard.read(key: .userAccount) as? String,
              Keychain.loadData(serviceIdentifier: identifier, forKey: account) != nil else {
            Logger.debug(error: SocialLoginError.noToken, message: "No Token")
            _guestState.send(true)
            return
        }
        _guestState.send(false)
        
    }
 
}
