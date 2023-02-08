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
    
    func fetchCodyList(weather: WeatherTag) async throws -> FitftyMainCodyListResponse
    
    func fetchMyInfo() async throws -> FitftyMyTagsResponse
    
}

public final class DefaultFitftyRepository: FitftyRepository {
    
    public init() {}
    
    public func fetchCodyList(weather: WeatherTag) async throws -> FitftyMainCodyListResponse {
        let request = try CodyListRequest(weather: weather).asDictionary()
        return try await FitftyAPI.request(
            target: .codyList(parameters: request),
            dataType: FitftyMainCodyListResponse.self
        )
    }
    
    public func fetchMyInfo() async throws -> FitftyMyTagsResponse {
        return try await FitftyAPI.request(target: .mySettings, dataType: FitftyMyTagsResponse.self)
    }
}
