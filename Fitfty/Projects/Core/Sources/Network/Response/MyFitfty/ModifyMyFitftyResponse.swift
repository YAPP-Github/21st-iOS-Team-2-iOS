//
//  ModifyMyFitftyResponse.swift
//  Core
//
//  Created by 임영선 on 2023/02/13.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct ModifyMyFitftyResponse: Codable {
    public let result: String
    public let data: String?
    public let message: String?
    public let errorCode: String?
}
