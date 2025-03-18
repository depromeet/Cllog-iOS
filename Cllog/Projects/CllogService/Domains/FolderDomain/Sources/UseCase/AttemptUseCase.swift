//
//  AttemptListUseCase.swift
//  FolderDomain
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

import Dependencies

public protocol AttemptUseCase {
    // TODO: 필터링 VO 삽입
    func getAttempts() async throws -> [Attempt]
    func getFilteredAttempts() async throws -> [Attempt]
}

public struct DefaultAttemptUseCase: AttemptUseCase {
    private let repository: AttemptRepository
    
    public init(repository: AttemptRepository) {
        self.repository = repository
    }
    
    public func getAttempts() async throws -> [Attempt] {
        try await repository.getFilteredAttempts()
    }
    
    public func getFilteredAttempts() async throws -> [Attempt] {
        try await repository.getFilteredAttempts()
    }
    
    
}

// TODO: Remove
public struct MockAttemptUseCase: AttemptUseCase {
    
    private let attemptRepository: AttemptRepository
    
    public init(attemptRepository: AttemptRepository) {
        self.attemptRepository = attemptRepository
    }
    
    public func getAttempts() async throws -> [Attempt] {
        try await attemptRepository.getFilteredAttempts()
    }
    
    public func getFilteredAttempts() async throws -> [Attempt] {
        try await attemptRepository.getFilteredAttempts()
    }
}

enum AttemptUseCaseKey: DependencyKey {
//    static let liveValue: AttemptUseCase = MockAttemptUseCase(attemptRepository: MockAttemptRepository())
    static let liveValue: AttemptUseCase = ClLogDI.container.resolve(AttemptUseCase.self)!
//    static let liveValue = ClLogDI.container.resolve(FolderListUseCase.self)!
}

extension DependencyValues {
    public var attemptUseCase: AttemptUseCase {
        get { self[AttemptUseCaseKey.self] }
        set { self[AttemptUseCaseKey.self] = newValue }
    }
}
