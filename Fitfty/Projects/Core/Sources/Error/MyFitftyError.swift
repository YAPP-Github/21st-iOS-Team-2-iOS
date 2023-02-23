//
//  MyFitftyError.swift
//  Core
//
//  Created by 임영선 on 2023/02/23.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum MyFitftyError: Error {
    case noWeather
    case failUpload
    case failModify
    case failGetPost
    case others(String)
}

extension MyFitftyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noWeather:
            return NSLocalizedString("날씨를 불러오는데 실패했어요.\n해외 사진은 날씨 조회가 불가능해요.", comment: "noWeather")
        case .failUpload:
            return NSLocalizedString("핏프티 등록에 실패했어요. 잠시 후 다시 시도해 주세요.", comment: "failUpload")
        case .failModify:
            return NSLocalizedString("핏프티 수정에 실패했어요. 잠시 후 다시 시도해 주세요.", comment: "failModify")
        case .failGetPost:
            return NSLocalizedString("핏프티 정보를 가져오는데 실패했어요. 잠시 후 다시 시도해 주세요.", comment: "failGetPost")
        case .others(let message):
            return NSLocalizedString(message, comment: "Others Message")
        }
    }
}
