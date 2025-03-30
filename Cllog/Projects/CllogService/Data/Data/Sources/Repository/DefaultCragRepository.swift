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

public actor DefaultCragRepository: CragRepository {
    private var cursor: Double = 0
    private var hasMore: Bool = true
    private let dataSource: CragDataSource
    
    public init(dataSource: CragDataSource) {
        self.dataSource = dataSource
    }
    
    public func getNearByCrags(
        longitude: Double?,
        latitude: Double?
    ) async throws -> [Crag] {
        let (crags, meta) = try await dataSource.nearByCrags(
            longitude: longitude,
            latitude: latitude,
            cursor: cursor
        )
        
        self.cursor = meta?.nextCursor ?? 0
        self.hasMore = meta?.hasMore ?? false
        
        return crags.map { $0.toDomain() }
    }
    
    public func getMyCrags() async throws -> [Crag] {
        let (crags, meta) = try await dataSource.myCrags(cursor: cursor)
        return crags.map { $0.toDomain() }
    }
    
    public func getCurrentCursor() -> Double {
        return cursor
    }
    
    public func getHasMore() -> Bool {
        return hasMore
    }
}
