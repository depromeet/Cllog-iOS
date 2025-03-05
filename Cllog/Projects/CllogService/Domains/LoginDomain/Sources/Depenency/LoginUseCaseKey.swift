//
//  LoginDepenency.swift
//  LoginDomain
//
//  Created by soi on 3/5/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture

enum LoginUseCaseKey: DependencyKey {
    static var liveValue: LoginUseCase? = nil
}

extension DependencyValues {
    public var loginUseCase: LoginUseCase {
        get {
            guard let useCase = self[LoginUseCaseKey.self] else {
                fatalError("Login UseCase 주입 필요")
            }
            return useCase
        }
        set { self[LoginUseCaseKey.self] = newValue }
    }
}
