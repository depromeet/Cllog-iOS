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
            Grade(name: "파랑", hexCode: 0x5E7CFF),
            Grade(name: "파랑", hexCode: 0x5E7CF3),
            Grade(name: "파랑", hexCode: 0x5E7CF2),
            Grade(name: "파랑", hexCode: 0x5E7CF1),
            Grade(name: "파랑", hexCode: 0x5E7CF7),
            Grade(name: "파랑", hexCode: 0x5E7C4F),
            Grade(name: "파랑", hexCode: 0x5E7C5F),
            Grade(name: "파랑", hexCode: 0x5E7C2F),
            Grade(name: "파랑", hexCode: 0x5E77FF),
            Grade(name: "파랑", hexCode: 0x5E75FF),
            Grade(name: "파랑", hexCode: 0x5E74FF),
            Grade(name: "파랑", hexCode: 0x5E73FF),
            Grade(name: "파랑", hexCode: 0x5E5CFF)
            
        ]
    }
    
    public func getFilteredAttempts() async throws -> [Attempt] {
        []
    }
}
