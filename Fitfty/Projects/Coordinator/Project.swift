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
        .Project.Auth,
        .Project.MainFeed,
        .Project.Onboarding,
        .Project.Profile,
        .Project.Setting,
        .package(product: "Amplify"),
        .package(product: "AWSCognitoAuthPlugin"),
        .package(product: "AWSS3StoragePlugin"),
        .package(product: "AWSAPIPlugin"),
        .package(product: "AWSDataStorePlugin")
    ]
)
