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
    
    public func patchResult(attempt: ReadAttempt, result: AttemptResult) async throws {
        try await dataSource.patch(id: attempt.problemId, cragId: nil, gradeId: nil, unregisterGrade: nil, result: result.rawValue)
    }
    
    public func patchInfo(attempt: ReadAttempt, grade: Grade? = nil, crag: Crag? = nil) async throws {
        try await dataSource.patch(
            id: attempt.problemId,
            cragId: crag?.id,
            gradeId: grade?.id,
            unregisterGrade: grade == nil,
            result: nil
        )
    }
}
