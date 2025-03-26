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
    
    public func getNearByCrags(longitude: Double, latitude: Double) async throws -> [Crag] {
        try await dataSource.nearByCrags(longitude: longitude, latitude: latitude).map { $0.toDomain() }
    }
    
    public func getMyCrags() async throws -> [Crag] {
        try await dataSource.myCrags().map { $0.toDomain()  }
    }
}
