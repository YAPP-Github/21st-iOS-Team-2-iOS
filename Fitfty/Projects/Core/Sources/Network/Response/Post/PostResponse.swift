//
//  Post.swift
//  Core
//
//  Created by 임영선 on 2023/02/09.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct PostResponse: Codable {
    
    let result: String
    let data: PostData
    let message: String?
    let errorCode: String?
    
}

// MARK: - DataClass
struct PostData: Codable {
    
    let boardToken, nickname: String
    let profilePictureUrl: String?
    let filePath: String
    let content, location: String
    let temperature: Int
    let cloudType, photoTakenTime: String
    let views, bookmarkCnt: Int
    
}
