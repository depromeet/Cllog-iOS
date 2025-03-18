//
//  DefaultCragRepository.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain
import Shared

public struct DefaultCragRepository: CragRepository {
    private let dataSource: CragDataSource
    
    public init(dataSource: CragDataSource) {
        self.dataSource = dataSource
    }
    
    public func getCrags() async throws -> [Crag] {
        try await dataSource.crags().map { $0.toDomain()  }
    }
}
