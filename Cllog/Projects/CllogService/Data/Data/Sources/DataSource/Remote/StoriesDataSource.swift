//
//  StoriesDataSource.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Starlink

public protocol StoriesDataSource {
    func stories(_ storyId: String) async throws -> StoryResponseDTO
    func summary(_ storyId: String) async throws -> StorySummaryResponseDTO
}

public final class DefaultStoriesDataSource: StoriesDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func stories(_ storyId: String) async throws -> StoryResponseDTO {
        let response: BaseResponseDTO<StoryResponseDTO> = try await provider.request(
            StoriesTarget.stories(storyId)
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }
    
    public func summary(_ storyId: String) async throws -> StorySummaryResponseDTO{
        let response: BaseResponseDTO<StorySummaryResponseDTO> = try await provider.request(
            StoriesTarget.stories(storyId)
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }
}

enum StoriesTarget {
    case stories(String)
    case summary(String)
}

extension StoriesTarget: EndpointType {
    var baseURL: String {
        return "https://dev-api.climb-log.my/api/v1/stories"
    }
    
    var path: String {
        switch self {
        case .stories(let storyId):
            return "/\(storyId)"
        case .summary(let storyId):
            return "/\(storyId)/summary"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .stories, .summary:
            return .get
        }
    }
    
    var parameters: ParameterType? {
        switch self {
        case .stories, .summary:
            return .none
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .stories, .summary:
            return .none
        }
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
}
