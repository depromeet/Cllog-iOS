//
//  GradeUseCaseKey.swift
//  FolderDomain
//
//  Created by soi on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import ComposableArchitecture

enum GradeUseCaseKey: DependencyKey {
    static let liveValue: GradeUseCase = MockGradeUseCase(gradeRepository: MockGradeRepository())
}

extension DependencyValues {
    public var gradeUseCase: GradeUseCase {
        get { self[GradeUseCaseKey.self] }
        set { self[GradeUseCaseKey.self] = newValue }
    }
}
