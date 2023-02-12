//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Core",
    product: .staticFramework,
    dependencies: [
        .SPM.Moya,
        .SPM.KakaoSDKAuth,
        .SPM.KakaoSDKUser,
        .SPM.KakaoSDKCommon,
        .Project.Common
    ]
)
