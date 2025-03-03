//
//  HomeFeatureAssembly.swift
//  Cllog
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Domain

import Swinject

struct HomeFeatureAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(HomeFeature.self) { resolver in
            
            guard let logConsoleUseCase  = resolver.resolve(LogConsoleUseCase.self) else {
                fatalError("Could not resolve LogUseCase")
            }
            
            return HomeFeature(
                logConsoleUseCase: logConsoleUseCase
            )
        }
    }
    
    
}
