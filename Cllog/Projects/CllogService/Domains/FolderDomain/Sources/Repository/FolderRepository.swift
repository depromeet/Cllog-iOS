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
    func getFilteredStories() async throws -> [Story]
}

// TODO: Remove
public struct MockFolderRepository: FolderRepository {
    public init() {}
    
    public func getCrages() async throws -> [Crag] {
        []
    }
    
    public func getGrades() async throws -> [Grade] {
        []
    }
    
    public func getFilteredStories() async throws -> [Story] {
        []
    }
}
