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

enum FolderListUseCaseKey: DependencyKey {
    static let liveValue = ClLogDI.container.resolve(FolderListUseCase.self)!
}

extension DependencyValues {
    public var loginUseCase: FolderListUseCase {
        get { self[FolderListUseCaseKey.self] }
        set { self[FolderListUseCaseKey.self] = newValue }
    }
}
