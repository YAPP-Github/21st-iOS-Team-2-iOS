//
//  FitftyFont.swift
//  Common
//
//  Created by Watcha-Ethan on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

public enum FitftyFont {
    case appleSDThin(size: CGFloat)
    case appleSDRegular(size: CGFloat)
    case appleSDUltraLight(size: CGFloat)
    case appleSDLight(size: CGFloat)
    case appleSDMedium(size: CGFloat)
    case appleSDSemiBold(size: CGFloat)
    case appleSDBold(size: CGFloat)
}

extension FitftyFont {
    public var font: UIFont? {
        switch self {
        case .appleSDThin(let size):
            return UIFont(name: "AppleSDGothicNeo-Thin", size: size)
        case .appleSDRegular(let size):
            return UIFont(name: "AppleSDGothicNeo-Regular", size: size)
        case .appleSDUltraLight(let size):
            return UIFont(name: "AppleSDGothicNeo-UltraLight", size: size)
        case .appleSDLight(let size):
            return UIFont(name: "AppleSDGothicNeo-Light", size: size)
        case .appleSDMedium(let size):
            return UIFont(name: "AppleSDGothicNeo-Medium", size: size)
        case .appleSDSemiBold(let size):
            return UIFont(name: "AppleSDGothicNeo-SemiBold", size: size)
        case .appleSDBold(let size):
            return UIFont(name: "AppleSDGothicNeo-Bold", size: size)
        }
    }
}
