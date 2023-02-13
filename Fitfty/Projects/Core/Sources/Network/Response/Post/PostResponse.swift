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
    public let data: PostData?
    public let message: String?
    public let errorCode: String?
    
}

public struct PostData: Codable {
    
    public  let boardToken, userToken, nickname: String
    public let profilePictureUrl: String?
    public let filePath, content: String
    public let tagGroupInfo: TagGroup
    public let location: String?
    public let temperature: Int?
    public let cloudType, photoTakenTime: String?
    public let views, bookmarkCnt: Int
    public let bookmarked: Bool

}
