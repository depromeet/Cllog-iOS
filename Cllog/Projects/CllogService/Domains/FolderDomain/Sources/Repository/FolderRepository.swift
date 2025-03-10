//
//  FolderRepository.swift
//  FolderDomain
//
//  Created by soi on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol FolderRepository {
    func getCrages() async throws -> [Crag]
    func getGrades() async throws -> [Grade]
    func getFilteredAttempts() async throws -> [Attempt]
}

// TODO: Remove
public struct MockFolderRepository: FolderRepository {
    public init() {}
    
    public func getCrages() async throws -> [Crag] {
        [
            Crag(name: "강남점", address: "강남")
        ]
    }
    
    public func getGrades() async throws -> [Grade] {
        [
            Grade(title: "파랑", hexCode: 0x5E7CFF)
        ]
    }
    
    public func getFilteredAttempts() async throws -> [Attempt] {
        []
    }
}
