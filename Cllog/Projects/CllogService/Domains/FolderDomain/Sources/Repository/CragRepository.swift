//
//  CragRepository.swift
//  FolderDomain
//
//  Created by soi on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public protocol CragRepository {
    func getCrags() async throws -> [Crag]
}

// TODO: remove
public struct MockCragRepository: CragRepository {
    public init() {}
    public func getCrags() async throws -> [Crag] {
        [
            Crag(name: "강남점", address: "강남")
        ]
    }
}
