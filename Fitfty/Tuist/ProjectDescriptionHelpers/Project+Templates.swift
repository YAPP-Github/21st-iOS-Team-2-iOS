import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public extension Project {
    
    static func makeModule(
            name: String,
            platform: Platform = .iOS,
            product: Product,
            organizationName: String = "Fitfty",
            packages: [Package] = [],
            deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "14.0", devices: [.iphone, .ipad]),
            dependencies: [TargetDependency] = [],
            sources: SourceFilesList = ["Sources/**"],
            resources: ResourceFileElements? = nil,
            infoPlist: InfoPlist = .default
        ) -> Project {
            let settings: Settings = .settings(
                base: [:],
                configurations: [
                    .debug(name: .debug),
                    .release(name: .release)
                ], defaultSettings: .recommended)

            let appTarget = Target(
                name: name,
                platform: platform,
                product: product,
                bundleId: "\(organizationName).\(name)",
                deploymentTarget: deploymentTarget,
                infoPlist: infoPlist,
                sources: sources,
                resources: resources,
                scripts: [.SwiftLintShell],
                dependencies: dependencies
            )

            let testTarget = Target(
                name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "\(organizationName).\(name)Tests",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Tests/**"],
                dependencies: [.target(name: name)]
            )

            let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]

            let targets: [Target] = [appTarget, testTarget]

            return Project(
                name: name,
                organizationName: organizationName,
                packages: packages,
                settings: settings,
                targets: targets,
                schemes: schemes
            )
        }
    
}

extension Scheme {
    
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
    
}
