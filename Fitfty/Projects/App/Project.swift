//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Fitfty",
    platform: .iOS,
    product: .app,
    packages: [
        .remote(
            url: "https://github.com/aws-amplify/amplify-swift.git",
            requirement: .upToNextMajor(from: "2.0.0")
        )
    ],
    dependencies: [
        .project(target: "Coordinator", path: .relativeToRoot("Projects/Coordinator")),
        .package(product: "Amplify"),
        .package(product: "AWSAPIPlugin"),
        .package(product: "AWSDataStorePlugin"),
        .package(product: "AWSCognitoAuthPlugin"),
        .package(product: "AWSS3StoragePlugin")
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist"),
    entitlements: "Fitfty.entitlements"
)
