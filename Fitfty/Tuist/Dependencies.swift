//
//  Dependencies.swift
//  Config
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
        .remote(
            url: "https://github.com/kakao/kakao-ios-sdk",
            requirement: .upToNextMajor(from: "2.13.0")
        ),
        .remote(
            url: "https://github.com/Moya/Moya.git",
            requirement: .upToNextMajor(from: "15.0.0")
        ),
    ],
    platforms: [.iOS]
)
