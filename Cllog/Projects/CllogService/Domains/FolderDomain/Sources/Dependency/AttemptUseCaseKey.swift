//
//  FolderListUseCaseKey.swift
//  FolderDomain
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

import ComposableArchitecture

enum AttemptUseCaseKey: DependencyKey {
    static let liveValue: AttemptUseCase = MockAttemptUseCase(attemptRepository: MockAttemptRepository())
//    static let liveValue = ClLogDI.container.resolve(FolderListUseCase.self)!
}

extension DependencyValues {
    public var attemptUseCase: AttemptUseCase {
        get { self[AttemptUseCaseKey.self] }
        set { self[AttemptUseCaseKey.self] = newValue }
    }
}
