//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Profile",
    product: .staticFramework,
    dependencies: [
        .Project.Common,
        .Project.Core,
        .SPM.Moya,
        .SPM.Kingfisher,
        .package(product: "Amplify"),
        .package(product: "AWSCognitoAuthPlugin"),
        .package(product: "AWSS3StoragePlugin"),
        .package(product: "AWSAPIPlugin"),
        .package(product: "AWSDataStorePlugin")
    ]
)
