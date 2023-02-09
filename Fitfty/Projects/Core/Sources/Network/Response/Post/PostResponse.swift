//
//  Post.swift
//  Core
//
//  Created by 임영선 on 2023/02/09.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct PostResponse: Codable {
    
    public let result: String
    public let data: PostData
    public let message: String?
    public let errorCode: String?
    
}

// MARK: - DataClass
public struct PostData: Codable {
    
    public let boardToken, nickname: String
    public let profilePictureUrl: String?
    public let filePath: String
    public let content: String
    public let location: String
    public let temperature: Int
    public let cloudType: String
    public let photoTakenTime: String
    public let views: Int
    public let bookmarkCnt: Int
    
}
