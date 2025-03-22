//
//  DefaultAttemptRepository.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain
import Shared

public struct DefaultAttemptRepository: AttemptRepository {
    private let dataSource: AttemptDataSource
    
    public init(dataSource: AttemptDataSource) {
        self.dataSource = dataSource
    }
    
    public func getFilteredAttempts() async throws -> [Attempt] {
        try await dataSource.attempts().map { $0.toDomain() }
    }
    
    public func getAttempt(attemptId: Int) async throws -> ReadAttempt {
        try await dataSource.attempt(attemptId).toDomain()
    }
    
    public func deleteAttempt(attemptId: Int) async throws {
        try await dataSource.delete(attemptId)
    }
}
