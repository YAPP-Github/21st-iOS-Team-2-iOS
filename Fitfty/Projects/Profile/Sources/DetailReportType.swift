//
//  DetailReportType.swift
//  Profile
//
//  Created by 임영선 on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

enum DetailReportType {
    case OBSCENE
    case WEATHER
    case COPYRIGHT
    case INSULT
    case REPEAT
    case MISC
    
    var koreanDetailReport: String {
        switch self {
        case .OBSCENE:
            return "음란성/선정성"
        case .WEATHER:
            return "날씨 태그가 사진과 어울리지 않음"
        case .COPYRIGHT:
            return "지적재산권 침해"
        case .INSULT:
            return "혐오 / 욕설 / 인신공격"
        case .REPEAT:
            return "같은내용 반복게시"
        case .MISC:
            return "기타"
        }
    }
    
    var englishDetailReport: String {
        switch self {
        case .OBSCENE:
            return "OBSCENE"
        case .WEATHER:
            return "WEATHER"
        case .COPYRIGHT:
            return "COPYRIGHT"
        case .INSULT:
            return "INSULT"
        case .REPEAT:
            return "REPEAT"
        case .MISC:
            return "MISC"
        }
    }
}
