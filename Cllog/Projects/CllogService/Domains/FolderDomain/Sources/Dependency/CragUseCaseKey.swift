//
//  CragUseCaseKey.swift
//  FolderDomain
//
//  Created by soi on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

enum CragUseCaseKey: DependencyKey {
    static let liveValue: CragUseCase = MockCragUseCase(cragRepository: MockCragRepository())
}

extension DependencyValues {
    public var cragUseCase: CragUseCase {
        get { self[CragUseCaseKey.self] }
        set { self[CragUseCaseKey.self] = newValue }
    }
}
