//
//  AttemptListUseCase.swift
//  FolderDomain
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol AttemptUseCase {
    // TODO: 필터링 VO 삽입
    func getAttempts() async throws -> [Attempt]
    func getFilteredAttempts() async throws -> [Attempt]
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
