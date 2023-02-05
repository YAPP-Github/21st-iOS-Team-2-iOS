//
//  AddressConversionResponse.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

// MARK: - AddressConversionResponse
struct AddressConversionResponse: Codable {
    let meta: AddressConversionMeta
    let documents: [AddressConversionResult]
}

// MARK: - Document
struct AddressConversionResult: Codable {
    let roadAddress: AddressConversionRoadAddress?
    let address: AddressConversionAddress

    enum CodingKeys: String, CodingKey {
        case roadAddress = "road_address"
        case address
    }
}

// MARK: - Address
struct AddressConversionAddress: Codable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let mountainYn: String
    let mainAddressNo: String
    let subAddressNo: String
    let zipCode: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case mountainYn = "mountain_yn"
        case mainAddressNo = "main_address_no"
        case subAddressNo = "sub_address_no"
        case zipCode = "zip_code"
    }
}

// MARK: - RoadAddress
struct AddressConversionRoadAddress: Codable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let roadName: String
    let undergroundYn: String
    let mainBuildingNo: String
    let subBuildingNo: String
    let buildingName: String
    let zoneNo: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case undergroundYn = "underground_yn"
        case mainBuildingNo = "main_building_no"
        case subBuildingNo = "sub_building_no"
        case buildingName = "building_name"
        case zoneNo = "zone_no"
    }
}

// MARK: - Meta
struct AddressConversionMeta: Codable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}
