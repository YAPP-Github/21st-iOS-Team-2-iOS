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
    let meta: SearchAddressMeta
}

// MARK: - Document
struct SearchAddressResult: Codable {
    let addressName: String
    let addressType: String
    let x: String
    let y: String
    var roadAddress: RoadAddressResponse?
    let address: AddressResponse?

    enum CodingKeys: String, CodingKey {
        case address, x, y
        case addressName = "address_name"
        case addressType = "address_type"
        case roadAddress = "road_address"
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
        case x, y
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
    }
}

// MARK: - RoadAddress
struct RoadAddressResponse: Codable {
    let addressName: String
    let buildingName: String
    let mainBuildingNo: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let roadName: String
    let subBuildingNo: String
    let undergroundYn: String
    let x: String
    let y: String
    let zoneNo: String

    enum CodingKeys: String, CodingKey {
        case x, y
        case addressName = "address_name"
        case buildingName = "building_name"
        case mainBuildingNo = "main_building_no"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case subBuildingNo = "sub_building_no"
        case undergroundYn = "underground_yn"
        case zoneNo = "zone_no"
    }
}


// MARK: - Meta
struct SearchAddressMeta: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
