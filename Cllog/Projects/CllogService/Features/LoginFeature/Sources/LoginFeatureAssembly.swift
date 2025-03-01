//
//  LoginFeatureAssembly.swift
//  LoginFeature
//
//  Created by soi on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Swinject
import LoginDomain
import Data

public struct LoginFeatureAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        
        container.register(LoginRepository.self) { _ in
            DefaultLoginRepository()
        }
        
        container.register(LoginUseCase.self) { resolver in
            guard let repository = resolver.resolve(LoginRepository.self) else {
                fatalError("LoginRepository dependency could not be resolved")
            }
            
            return DefaultLoginUseCase(loginRepository: repository)
        }
        
        container.register(LoginFeature.self) { resolver in
            let useCase = resolver.resolve(LoginUseCase.self)!
            return LoginFeature(useCase: useCase)
        }
    }
}
