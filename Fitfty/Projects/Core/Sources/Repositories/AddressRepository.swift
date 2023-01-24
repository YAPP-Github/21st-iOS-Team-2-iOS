//
//  AddressRepository.swift
//  Core
//
//  Created by Ari on 2023/01/24.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

protocol AddressRepository {
    
    func fetchAddressList(search: String) async throws -> [Address]
    
}

public final class DefaultAddressRepository: AddressRepository {
    
    public init() {}
    
    public func fetchAddressList(search: String) async throws -> [Address] {
        let request = try SearchAddressRequest(query: search, page: 1, size: 30).asDictionary()
        let response = try await KakaoAPI.request(
            target: .fetchSearchAddress(parameter: request),
            dataType: SearchAddressResponse.self
        )
        return response.documents.map {
            let firstName = $0.address?.region1DepthName ?? $0.roadAddress?.region1DepthName ?? ""
            let secondName = $0.address?.region2DepthName ?? $0.roadAddress?.region2DepthName ?? ""
            let thirdName = $0.address?.region3DepthName.isEmpty == true ?
                            $0.address?.region3DepthHName ?? "" :
                            $0.roadAddress?.region3DepthName ?? $0.address?.region3DepthName ?? ""
            return Address(
                fullName: $0.addressName,
                x: $0.x,
                y: $0.y,
                firstName: firstName,
                secondName: secondName,
                thirdName: thirdName
            )
        }
    }
    
}
