//
//  CragUseCase.swift
//  FolderDomain
//
//  Created by soi on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

import Dependencies

public protocol CragUseCase {
    func getCrags() async throws -> [Crag]
}

// TODO: Remove
public struct MockCragUseCase: CragUseCase {
    private let cragRepository: CragRepository
    
    public init(cragRepository: CragRepository) {
        self.cragRepository = cragRepository
    }
    
    public func getCrags() async throws -> [Crag] {
        try await cragRepository.getCrags()
    }
}

enum CragUseCaseKey: DependencyKey {
    static let liveValue: CragUseCase = MockCragUseCase(cragRepository: MockCragRepository())
}

extension DependencyValues {
    public var cragUseCase: CragUseCase {
        get { self[CragUseCaseKey.self] }
        set { self[CragUseCaseKey.self] = newValue }
    }
}
