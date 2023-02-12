//
//  AmplifyManager.swift
//  Core
//
//  Created by Ari on 2023/02/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Amplify
import AWSS3StoragePlugin
import AWSCognitoAuthPlugin
import AWSPluginsCore

public final class AmplifyManager {
    
    public static let shared = AmplifyManager()
    
    private init() {}
    
    public func getURL(fileName: String) async throws -> URL {
        let url = try await Amplify.Storage.getURL(key: "\(fileName).jpg")
        if var components = URLComponents(string: url.absoluteString) {
            components.query = nil
            return components.url ?? url
        } else {
            return url
        }
    }
    
    public func uploadImage(data: Data, fileName: String) async throws -> URL {
        let uploadTask = Amplify.Storage.uploadData(
            key: "\(fileName).jpg",
            data: data
        )
        Task {
            for await progress in await uploadTask.progress {
                print("Progress: \(progress)")
            }
        }
        let value = try await uploadTask.value
        print("Completed: \(value)")
        return try await getURL(fileName: fileName)
    }
    
    public func delete(fileName: String) async throws {
        try await Amplify.Storage.remove(key: fileName)
    }
    
}
