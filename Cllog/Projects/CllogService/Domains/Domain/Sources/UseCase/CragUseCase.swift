//
//  CragUseCase.swift
//  Domain
// 
//  Created by soi on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain
import Shared

import Dependencies

public protocol CragUseCase {
    func getCrags() async throws -> [Crag]
    func nextCrags() async throws -> [Crag]
}

enum CragUseCaseKey: DependencyKey {
    static let liveValue: CragUseCase = ClLogDI.container.resolve(CragUseCase.self)!
}

extension DependencyValues {
    public var cragUseCase: CragUseCase {
        get { self[CragUseCaseKey.self] }
        set { self[CragUseCaseKey.self] = newValue }
    }
}

public struct DefaultCragUseCase: CragUseCase {
    public let cragRepository: CragRepository
    
    public init(cragRepository: CragRepository) {
        self.cragRepository = cragRepository
    }
    
    public func getCrags() async throws -> [Crag] {
        let currentLongitude: Double? = nil
        let currentLatitude: Double? = nil
        return try await cragRepository.getNearByCrags(longitude: currentLongitude, latitude: currentLatitude)
    }
    
    public func nextCrags() async throws -> [Crag] {
        []
    }
}
