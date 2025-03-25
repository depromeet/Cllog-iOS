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
    func stories(_ storyId: Int) async throws -> StoryResponseDTO
    func summary(_ storyId: Int) async throws -> StorySummaryResponseDTO
    func memo(_ request: EditMemoRequestDTO) async throws
    func delete(_ storyId: Int) async throws
    func save(_ request: StoryRequestDTO) async throws -> SaveStoryResponseDTO
}

public final class DefaultStoriesDataSource: StoriesDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func stories(_ storyId: Int) async throws -> StoryResponseDTO {
        let response: BaseResponseDTO<StoryResponseDTO> = try await provider.request(
            StoriesTarget.stories(storyId)
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }
    
    public func summary(_ storyId: Int) async throws -> StorySummaryResponseDTO{
        let response: BaseResponseDTO<StorySummaryResponseDTO> = try await provider.request(
            StoriesTarget.summary(storyId)
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }
    
    public func memo(_ request: EditMemoRequestDTO) async throws {
        let _: BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            StoriesTarget.memo(request)
        )
    }
    
    public func delete(_ storyId: Int) async throws {
        let _: BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            StoriesTarget.delete(storyId)
        )
    }
    
    public func save(_ request: StoryRequestDTO) async throws -> SaveStoryResponseDTO {
        let response: BaseResponseDTO<SaveStoryResponseDTO> = try await provider.request(
            StoriesTarget.save(request)
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }
}

enum StoriesTarget {
    case stories(Int)
    case summary(Int)
    case memo(EditMemoRequestDTO)
    case delete(Int)
    case save(StoryRequestDTO)
}

extension StoriesTarget: EndpointType {
    var baseURL: String {
        return Environment.baseURL + "/api/v1/stories"
    }
    
    var path: String {
        switch self {
        case .stories(let storyId):
            return "/\(storyId)"
        case .summary(let storyId):
            return "/\(storyId)/summary"
        case .memo(let request):
            return "/\(request.storyId)/memo"
        case .delete(let storyId):
            return "/\(storyId)"
        case .save:
            return ""
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .stories, .summary:
            return .get
        case .memo:
            return .patch
        case .delete:
            return .delete
        case .save:
            return .post
        }
    }
    
    var parameters: ParameterType? {
        switch self {
        case .stories, .summary, .delete:
            return .none
        case .memo(let request):
            return .encodable(request.body)
        case .save(let request):
            return .encodable(request)
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .stories, .summary, .memo, .delete, .save:
            return .none
        }
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
    
    var encoding: StarlinkEncodable {
        switch self {
        case .stories, .summary, .delete:
            return Starlink.StarlinkURLEncoding()
        case .memo, .save:
            return Starlink.StarlinkJSONEncoding()
        }
        
    }
}
