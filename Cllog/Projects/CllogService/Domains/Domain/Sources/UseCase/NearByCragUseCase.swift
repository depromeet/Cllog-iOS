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
    func fetch(keyword: String, location: Location?) async throws -> [Crag]
    func next() async throws -> [Crag]
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

public final class DefaultNearByCragUseCase: NearByCragUseCase {
    private let repository: NearByCragRepository
    
    private var userLocation: Location?
    
    public init(
        repository: NearByCragRepository
    ) {
        self.repository = repository
    }
    
    public func fetch(keyword: String, location: Location?) async throws -> [Crag] {
        do {
            self.userLocation = location
            guard let location else {
                return try await repository.fetch(longitude: nil, latitude: nil, keyword: keyword)
            }
            return try await repository.fetch(longitude: location.longitude, latitude: location.latitude, keyword: keyword)
        } catch {
            return try await repository.fetch(longitude: nil, latitude: nil, keyword: keyword)
        }
    }
    
    public func next() async throws -> [Crag] {
        return try await repository.fetchMore(longitude: userLocation?.longitude, latitude: userLocation?.latitude)
    }
    
}
