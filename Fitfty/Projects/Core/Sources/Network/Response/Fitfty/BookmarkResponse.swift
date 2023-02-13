//
//  BookmarkResponse.swift
//  Core
//
//  Created by Ari on 2023/02/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct BookmarkResponse: Codable {
    public let result: FitftyResult
    public let data: String?
    public let message: String?
    public let errorCode: String?
}
