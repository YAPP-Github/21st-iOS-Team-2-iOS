//
//  SearchAddressResponse.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct SearchAddressResponse: Codable {
    let documents: [SearchAddressResult]
    let meta: MetaResponse
}

// MARK: - Document
struct SearchAddressResult: Codable {
    let address: AddressResponse
    let addressName: String
    let addressType: String
    var roadAddress: String?
    let x: String
    let y: String

    enum CodingKeys: String, CodingKey {
        case address
        case addressName = "address_name"
        case addressType = "address_type"
        case roadAddress = "road_address"
        case x, y
    }
}

// MARK: - Address
struct AddressResponse: Codable {
    let addressName: String
    let bCode: String
    let hCode: String
    let mainAddressNo: String
    let mountainYn: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthHName: String
    let region3DepthName: String
    let subAddressNo: String
    let x: String
    let y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case bCode = "b_code"
        case hCode = "h_code"
        case mainAddressNo = "main_address_no"
        case mountainYn = "mountain_yn"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthHName = "region_3depth_h_name"
        case region3DepthName = "region_3depth_name"
        case subAddressNo = "sub_address_no"
        case x, y
    }
}

// MARK: - Meta
struct MetaResponse: Codable {
    let isEnd: Bool
    let pageableCount: String
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
