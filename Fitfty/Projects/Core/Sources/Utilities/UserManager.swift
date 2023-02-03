//
//  UserManager.swift
//  Core
//
//  Created by Ari on 2023/02/03.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public protocol UserManager {
    var isNewUser: Bool { get }
    var currentLocation: Address? { get }
    
    func updateUserState(_ state: Bool)
    func updateCurrentLocation(_ address: Address)
}

public final class DefaultUserManager {
    
    private let localStorage: LocalStorageService
    
    public init(localStorage: LocalStorageService = UserDefaults.standard) {
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
    
    public func updateUserState(_ state: Bool) {
        localStorage.write(key: .isNewUser, value: state)
    }
    
    public func updateCurrentLocation(_ address: Address) {
        guard let address = try? address.asDictionary() else {
            return
        }
        localStorage.write(key: .currentLocation, value: address)
    }
    
}
