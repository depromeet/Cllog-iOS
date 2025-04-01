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
import CoreLocation

public actor DefaultNearByCragRepository: NearByCragRepository {
    
    private var cursor: Double?
    private var hasMore: Bool = true
    private let dataSource: CragDataSource
//    private let locationService: LocationService
    private var currentLocation: CLLocation?
    
    public init(
        dataSource: CragDataSource
//        locationService: LocationService
    ) {
        self.dataSource = dataSource
//        self.locationService = locationService
    }
    
    public func fetch(longitude: Double?, latitude: Double?) async throws -> [Crag] {
        self.cursor = nil
        self.hasMore = true
        if currentLocation == nil {
//            let location = try await locationService.requestPermission() // 위치 권한 요청
//            currentLocation = location
        }
        let currentLongitude = currentLocation?.coordinate.longitude
        let currentLatitude = currentLocation?.coordinate.latitude
        
        return try await fetchMore(longitude: currentLongitude, latitude: currentLatitude)
    }
    
    public func fetchMore(longitude: Double?, latitude: Double?) async throws -> [Crag] {
        guard hasMore else { return [] }
        
        let currentLongitude = longitude ?? currentLocation?.coordinate.longitude
        let currentLatitude = latitude ?? currentLocation?.coordinate.latitude
        
        let (crags, meta) = try await dataSource.nearByCrags(longitude: currentLongitude, latitude: currentLatitude, cursor: cursor)
        
        self.cursor = meta?.nextCursor ?? 0
        self.hasMore = meta?.hasMore ?? false
        
        return crags.map { $0.toDomain() }
    }
}
