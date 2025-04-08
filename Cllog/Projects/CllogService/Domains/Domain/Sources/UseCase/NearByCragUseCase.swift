//
//  NearByCragUseCase.swift
//  Domain
//
//  Created by soi on 3/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Shared

import Dependencies

public protocol NearByCragUseCase {
    func fetch(location: Location?) async throws -> [Crag]
    func next(location: Location?) async throws -> [Crag]
}

enum NearByCragUseCaseKey: DependencyKey {
    static let liveValue: NearByCragUseCase = ClLogDI.container.resolve(NearByCragUseCase.self)!
}

extension DependencyValues {
    public var nearByCragUseCase: NearByCragUseCase {
        get { self[NearByCragUseCaseKey.self] }
        set { self[NearByCragUseCaseKey.self] = newValue }
    }
}

public struct DefaultNearByCragUseCase: NearByCragUseCase {
    // TODO: fetch 할 때 location 캐싱 및 .. 어쩌고 ..
    public let repository: NearByCragRepository
    
    public init(repository: NearByCragRepository) {
        self.repository = repository
    }
    
    public func fetch(location: Location?) async throws -> [Crag] {
        let currentLongitude: Double? = nil
        let currentLatitude: Double? = nil
        return try await repository.fetch(longitude: currentLongitude, latitude: currentLatitude)
    }
    
    public func next(location: Location?) async throws -> [Crag] {
        let currentLongitude: Double? = nil
        let currentLatitude: Double? = nil
        return try await repository.fetchMore(longitude: currentLongitude, latitude: currentLatitude)
    }
    
}
