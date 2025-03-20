//
//  ValidateUserSessionUseCase.swift
//  AccountDomain
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public protocol ValidateUserSessionUseCase {
    func fetch() -> Bool
}

public struct ValidateUserSession: ValidateUserSessionUseCase {
    public init(repository: TokenRepository) {
        self.repository = repository
    }
    
    private let repository: TokenRepository
    
    public func fetch() -> Bool {
        repository.fetchValidateUserSession()
    }
}

public struct MockValidateUserSession: ValidateUserSessionUseCase {
    public func fetch() -> Bool {
        return true
    }
}

public enum ValidateUserSessionDependencyKey: DependencyKey {
    public static var liveValue: any ValidateUserSessionUseCase = ClLogDI.container.resolve(ValidateUserSessionUseCase.self)!
    
    public static var testValue: any ValidateUserSessionUseCase = MockValidateUserSession()
    
    public static var previewValue: any ValidateUserSessionUseCase = MockValidateUserSession()
}

public extension DependencyValues {
    var validateUserSessionUseCase: any ValidateUserSessionUseCase {
        get { self[ValidateUserSessionDependencyKey.self] }
        set { self[ValidateUserSessionDependencyKey.self] = newValue }
    }
}
