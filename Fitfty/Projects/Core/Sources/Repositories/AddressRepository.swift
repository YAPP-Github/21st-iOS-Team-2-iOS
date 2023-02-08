//
//  AddressRepository.swift
//  Core
//
//  Created by Ari on 2023/01/24.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public protocol AddressRepository {
    
    func fetchAddressList(search: String) async throws -> [Address]
    
    func fetchAddress(longitude: Double, latitude: Double) async throws -> Address
    
}

public final class DefaultAddressRepository: AddressRepository {
    
    public init() {}
    
    public func fetchAddressList(search: String) async throws -> [Address] {
        let request = try SearchAddressRequest(query: search, page: 1, size: 30).asDictionary()
        let response = try await KakaoAKAPI.request(
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
    
    public func fetchAddress(longitude: Double, latitude: Double) async throws -> Address {
        let searchAddress = AddressConversionRequest(x: longitude, y: latitude)
        let response = try await KakaoAKAPI.request(
            target: KakaoAKAPI.fetchAddressConversion(parameter: try searchAddress.asDictionary()),
            dataType: AddressConversionResponse.self
        )
        guard let address = response.documents.first?.address else {
            throw ResultCode.nodataError
        }
        return Address(
            fullName: address.addressName,
            x: longitude.description,
            y: latitude.description,
            firstName: address.region1DepthName,
            secondName: address.region2DepthName,
            thirdName: address.region3DepthName
        )
    }
    
}
