//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Coordinator",
    product: .staticFramework,
    dependencies: [
        .Projcet.Auth,
        .Projcet.MainFeed,
        .Projcet.Profile,
        .Projcet.Setting
    ]
)
