//
//  SessionManager.swift
//  Core
//
//  Created by Watcha-Ethan on 2023/02/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

final public class SessionManager: NSObject {
    static public let shared = SessionManager()
    
    private override init() {}
    
    public func checkUserSession() async -> Bool {
        do {
            let response = try await FitftyAPI.request(target: .getUserPrivacy, dataType: UserPrivacyResponse.self)
            if response.result == "SUCCESS" {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    public func deleteUserSession() {
        Keychain.deleteTokenData()
    }
}
