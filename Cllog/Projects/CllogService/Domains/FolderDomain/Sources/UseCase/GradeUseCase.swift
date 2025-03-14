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
    static let liveValue: GradeUseCase = MockGradeUseCase(gradeRepository: MockGradeRepository())
}

extension DependencyValues {
    public var gradeUseCase: GradeUseCase {
        get { self[GradeUseCaseKey.self] }
        set { self[GradeUseCaseKey.self] = newValue }
    }
}
