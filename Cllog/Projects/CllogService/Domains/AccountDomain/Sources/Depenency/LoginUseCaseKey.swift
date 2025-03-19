//
//  LoginDepenency.swift
//  AccountDomain
//
//  Created by soi on 3/5/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import Shared

enum LoginUseCaseKey: DependencyKey {
    static let liveValue = ClLogDI.container.resolve(LoginUseCase.self)!
}

extension DependencyValues {
    public var loginUseCase: LoginUseCase {
        get { self[LoginUseCaseKey.self] }
        set { self[LoginUseCaseKey.self] = newValue }
    }
}
