//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription

public extension TargetScript {

    static let SwiftLintShell = TargetScript.pre(
        path: .relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLintShell",
        basedOnDependencyAnalysis: false
    )
    
}
