//
//  DefaultNearByCragRepository.swift
//  Data
//
//  Created by soi on 3/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Domain
import Shared

public actor DefaultNearByCragRepository: NearByCragRepository {
    
    private var cursor: Double?
    private var hasMore: Bool = true
    private let dataSource: CragDataSource
    
    public init(dataSource: CragDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(longitude: Double?, latitude: Double?) async throws -> [Crag] {
        self.cursor = nil
        self.hasMore = true
        
        return try await fetchMore(longitude: longitude, latitude: latitude)
    }
    
    public func fetchMore(longitude: Double?, latitude: Double?) async throws -> [Crag] {
        guard hasMore else { return [] }
        
        let (crags, meta) = try await dataSource.nearByCrags(longitude: longitude, latitude: latitude, cursor: cursor)
        
        self.cursor = meta?.nextCursor ?? 0
        self.hasMore = meta?.hasMore ?? false
        
        return crags.map { $0.toDomain() }
    }
}
