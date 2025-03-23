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
}

enum StoriesTarget {
    case stories(Int)
    case summary(Int)
    case memo(EditMemoRequestDTO)
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
        case .memo(let request):
            return "/\(request.storyId)/memo"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .stories, .summary:
            return .get
        case .memo:
            return .patch
        }
    }
    
    var parameters: ParameterType? {
        switch self {
        case .stories, .summary:
            return .none
        case .memo(let request):
            return .encodable(request.body)
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .stories, .summary, .memo:
            return .none
        }
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
    
    var encoding: StarlinkEncodable {
        switch self {
        case .stories, .summary:
            return Starlink.StarlinkURLEncoding()
        case .memo:
            return Starlink.StarlinkJSONEncoding()
        }
        
    }
}
