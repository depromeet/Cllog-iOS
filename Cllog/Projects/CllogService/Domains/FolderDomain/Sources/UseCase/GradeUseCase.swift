//
//  GradeUseCase.swift
//  FolderDomain
//
//  Created by soi on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

import Dependencies

public protocol GradeUseCase {
    func getGrades() async throws -> [Grade]
}

public struct DefaultGradeUseCase: GradeUseCase {
    private let repository: GradeRepository
    
    public init(repository: GradeRepository) {
        self.repository = repository
    }
    
    public func getGrades() async throws -> [Grade] {
        try await repository.getGrades()
    }
}

// TODO: Remove
public struct MockGradeUseCase: GradeUseCase {
    private let gradeRepository: GradeRepository
    
    public init(gradeRepository: GradeRepository) {
        self.gradeRepository = gradeRepository
    }
    
    public func getGrades() async throws -> [Grade] {
        try await gradeRepository.getGrades()
    }
}

enum GradeUseCaseKey: DependencyKey {
    static let liveValue: GradeUseCase = ClLogDI.container.resolve(GradeUseCase.self)!
}

extension DependencyValues {
    public var gradeUseCase: GradeUseCase {
        get { self[GradeUseCaseKey.self] }
        set { self[GradeUseCaseKey.self] = newValue }
    }
}
