//
//  FitftyRepository.swift
//  Core
//
//  Created by Ari on 2023/02/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

public protocol FitftyRepository {
    
    func fetchCodyList(weather: WeatherTag, gender: Gender?, styles: [StyleTag]?) async throws -> FitftyMainCodyListResponse
    
    func fetchMyInfo() async throws -> FitftyMyTagsResponse
    
}

public final class DefaultFitftyRepository: FitftyRepository {
    
    public init() {}
    
    public func fetchCodyList(weather: WeatherTag, gender: Gender?, styles: [StyleTag]?) async throws -> FitftyMainCodyListResponse {
        let request: [String: Any] = try CodyListRequest(weather: weather, gender: gender, style: styles).asDictionary()
        let target: FitftyAPI
        if gender == nil {
            target = .codyList(parameters: request)
        } else {
            target = .filteredCodyList(parameters: request)
        }
        return try await FitftyAPI.request(
            target: target,
            dataType: FitftyMainCodyListResponse.self
        )
    }
    
    public func fetchMyInfo() async throws -> FitftyMyTagsResponse {
        return try await FitftyAPI.request(target: .mySettings, dataType: FitftyMyTagsResponse.self)
    }
}
