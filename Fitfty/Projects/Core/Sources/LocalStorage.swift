//
//  LocalStorage.swift
//  Core
//
//  Created by Ari on 2023/02/03.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum LocalKey: String {
    case isNewUser
    case currentLocation
    case userIdentifier
    case userAccount
}

public protocol LocalStorageService: AnyObject {
    func read(key: LocalKey) -> Any?
    func write(key: LocalKey, value: Any)
    func delete(key: LocalKey)
}

extension UserDefaults: LocalStorageService {
    public func read(key: LocalKey) -> Any? {
        return Self.standard.object(forKey: key.rawValue)
    }
    
    public func write(key: LocalKey, value: Any) {
        Self.standard.setValue(value, forKey: key.rawValue)
        Self.standard.synchronize()
    }
    
    public func delete(key: LocalKey) {
        Self.standard.setValue(nil, forKey: key.rawValue)
        Self.standard.synchronize()
    }
}
