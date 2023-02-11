//
//  Dependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let Moya = TargetDependency.external(name: "Moya")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
}
