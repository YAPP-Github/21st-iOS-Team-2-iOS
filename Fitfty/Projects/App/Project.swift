//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let infoPlist = InfoPlist.extendingDefault(with: [
    "NSAppTransportSecurity" : [
        "NSAllowsArbitraryLoads": "YES"
    ]
])

let project = Project.makeModule(
    name: "Fitfty",
    platform: .iOS,
    product: .app,
    dependencies: [
        .project(target: "Coordinator", path: .relativeToRoot("Projects/Coordinator"))
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
)
