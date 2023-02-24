//
//  MainFeedError.swift
//  Core
//
//  Created by Ari on 2023/02/23.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum MainFeedError: LocalizedError {
    case codyLoadFailed
    case setUpFailed
    case updateFailed
    case tagLoadFailed
    case bookmarkFailed
}

extension MainFeedError {
    public var errorDescription: String? {
        switch self {
        case .codyLoadFailed: return NSLocalizedString("코디를 불러오는데 실패했습니다.", comment: "No Cody")
        case .setUpFailed: return NSLocalizedString("메인화면 설정을 실패했습니다", comment: "Set up failed")
        case .updateFailed: return NSLocalizedString("메인화면 업데이트를 실패했습니다.", comment: "Update failed")
        case .tagLoadFailed: return NSLocalizedString("태그를 불러오는데 실패했습니다.", comment: "No Tag")
        case .bookmarkFailed: return NSLocalizedString("북마크를 반영하는데 실패했습니다.", comment: "Bookmark failed")
        }
    }
    
    public var userGuideErrorMessage: String {
        switch self {
        case .codyLoadFailed: return "코디 목록을 업데이트 하는데 알 수 없는 에러가 발생하여 실패하였습니다."
        case .setUpFailed: return "메인화면을 설정하는데 알 수 없는 에러가 발생하여 실패하였습니다."
        case .updateFailed: return "메인화면을 업데이트 하는데 알 수 없는 에러가 발생하여 실패하였습니다."
        case .tagLoadFailed: return "태그 설정을 불러오는데 알 수 없는 에러가 발생하여 실패하였습니다."
        case .bookmarkFailed: return "북마크 업데이트를 실패했습니다."
        }
    }
}
