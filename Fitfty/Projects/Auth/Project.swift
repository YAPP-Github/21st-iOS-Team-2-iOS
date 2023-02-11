//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Auth",
    product: .staticFramework,
    dependencies: [
        .Project.Common,
        .Project.Core,
        .SPM.Moya,
        .SPM.Kingfisher
    ]
)
