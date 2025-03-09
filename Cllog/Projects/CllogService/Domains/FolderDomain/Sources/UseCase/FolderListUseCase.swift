//
//  FolderListUseCase.swift
//  FolderDomain
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol FolderListUseCase {
    func getCrages() async throws -> [Crag]
    func getGrades() async throws -> [Grade]
    // TODO: 필터링 VO 삽입
    func getFilteredStories() async throws -> [Story]
}

// TODO: Remove
public struct MockFolderListUseCase: FolderListUseCase {
    private let folderRepository: FolderRepository
    
    public init(folderRepository: FolderRepository) {
        self.folderRepository = folderRepository
    }
    
    public func getCrages() async throws -> [Crag] {
        try await folderRepository.getCrages()
    }
    
    public func getGrades() async throws -> [Grade] {
        try await folderRepository.getGrades()
    }
    
    public func getFilteredStories() async throws -> [Story] {
        try await folderRepository.getFilteredStories()
    }
}
