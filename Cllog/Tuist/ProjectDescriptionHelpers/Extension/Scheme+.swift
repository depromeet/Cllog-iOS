//
//  AppScheme.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

import ProjectDescription

extension Scheme {
    static func configureAppScheme(
        schemeName: String
    ) -> [Scheme] {
        let developConfiguration: ConfigurationName = .configuration("Develop")
        let testConfiguration: ConfigurationName = .configuration("Test")
        let productionConfiguration: ConfigurationName = .configuration("Production")
        
        let buildAction = BuildAction.buildAction(targets: [TargetReference(stringLiteral: schemeName)])
        
        return [
            Scheme.scheme(
                name: schemeName + "-Develop",
                shared: true,
                buildAction: buildAction,
                runAction: .runAction(configuration: developConfiguration),
                archiveAction: .archiveAction(configuration: developConfiguration),
                profileAction: .profileAction(configuration: developConfiguration),
                analyzeAction: .analyzeAction(configuration: developConfiguration)
            ),
            Scheme.scheme(
                name: schemeName + "-Test",
                shared: true,
                buildAction: buildAction,
                runAction: .runAction(configuration: testConfiguration),
                archiveAction: .archiveAction(configuration: testConfiguration),
                profileAction: .profileAction(configuration: testConfiguration),
                analyzeAction: .analyzeAction(configuration: testConfiguration)
            ),
            Scheme.scheme(
                name: schemeName + "-Production",
                shared: true,
                buildAction: buildAction,
                runAction: .runAction(configuration: productionConfiguration),
                archiveAction: .archiveAction(configuration: productionConfiguration),
                profileAction: .profileAction(configuration: productionConfiguration),
                analyzeAction: .analyzeAction(configuration: productionConfiguration)
            )
        ]
    }
    
    static func configureDemoAppScheme(
        schemeName: String
    ) -> Scheme {
        let developConfiguration: ConfigurationName = .configuration("Develop")
        
        let buildAction = BuildAction.buildAction(targets: [TargetReference(stringLiteral: schemeName)])
        
        return Scheme.scheme(
            name: schemeName,
            shared: true,
            buildAction: buildAction,
            runAction: .runAction(configuration: developConfiguration),
            archiveAction: .archiveAction(configuration: developConfiguration),
            profileAction: .profileAction(configuration: developConfiguration),
            analyzeAction: .analyzeAction(configuration: developConfiguration)
        )
    }
    
    static func configureScheme(
        schemeName: String
    ) -> Scheme {
        let configuration: ConfigurationName = .configuration("Develop")
        
        let buildAction = BuildAction.buildAction(targets: [TargetReference(stringLiteral: schemeName)])
        
        return Scheme.scheme(
                name: schemeName,
                shared: true,
                buildAction: buildAction,
                runAction: .runAction(configuration: configuration),
                archiveAction: .archiveAction(configuration: configuration),
                profileAction: .profileAction(configuration: configuration),
                analyzeAction: .analyzeAction(configuration: configuration)
        )
    }
}
