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
        let currentLongitude = 126.9774418506923
        let currentLatitude = 37.56440029816974
        return try await cragRepository.getNearByCrags(longitude: currentLongitude, latitude: currentLatitude)
    }
}
