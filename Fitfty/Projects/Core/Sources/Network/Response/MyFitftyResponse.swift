//
//  MyFitfty.swift
//  Core
//
//  Created by 임영선 on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct MyFitftyResponse: Codable {
    public let result: String
    public let data: MyFitftyData?
    public let message: String?
    public let errorCode: String?
}

public struct MyFitftyData: Codable {
    public let boardToken: String
    public let content: String
    public let temperature: Int?
    public let location: String?
    public let cloudType: String?
    public let photoTakenTime: String
}
