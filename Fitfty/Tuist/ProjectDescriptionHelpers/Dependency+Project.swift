//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import ProjectDescription

public extension TargetDependency {
    enum Projcet {}
}

public extension TargetDependency.Projcet {
    static let Common = TargetDependency.project(target: "Common", path: .relativeToRoot("Projects/Common"))
    static let Core = TargetDependency.project(target: "Core", path: .relativeToRoot("Projects/Core"))
    static let Auth = TargetDependency.project(target: "Auth", path: .relativeToRoot("Projects/Auth"))
    static let MainFeed = TargetDependency.project(target: "MainFeed", path: .relativeToRoot("Projects/MainFeed"))
    static let Profile = TargetDependency.project(target: "Profile", path: .relativeToRoot("Projects/Profile"))
    static let Setting = TargetDependency.project(target: "Setting", path: .relativeToRoot("Projects/Setting"))
}

