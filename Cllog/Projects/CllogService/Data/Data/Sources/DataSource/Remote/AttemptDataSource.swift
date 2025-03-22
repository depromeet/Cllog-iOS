//
//  AttemptDataSource.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Starlink

public protocol AttemptDataSource {
    func attempts() async throws -> [FolderAttemptResponseDTO]
    func attempt(_ attemptId: Int) async throws -> DetailAttemptResponseDTO
    func delete(_ attemptId: Int) async throws
}

public final class DefaultAttemptDataSource: AttemptDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func attempts() async throws -> [FolderAttemptResponseDTO] {
        let response: BaseResponseDTO<FolderResponseDTO> = try await provider.request(
            AttemptTarget.attempts
        )
        
        guard let attempts = response.data?.attempts else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return attempts
    }
    
    public func attempt(_ attemptId: Int) async throws -> DetailAttemptResponseDTO {
        let response: BaseResponseDTO<DetailAttemptResponseDTO> = try await provider.request(AttemptTarget.detailAttempt(id: attemptId)
        )
        
        guard let attempt = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return attempt
    }
    
    public func delete(_ attemptId: Int) async throws {
        let _: EmptyResponseDTO = try await provider.request(AttemptTarget.delete(id: attemptId))
    }
}

enum AttemptTarget {
    case attempts
    case detailAttempt(id: Int)
    case delete(id: Int)
}

extension AttemptTarget: EndpointType {
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkURLEncoding()
    }
    
   
    var baseURL: String {
        return "https://dev-api.climb-log.my"
    }
    
    var path: String {
        switch self {
        case .attempts: "/api/v1/attempts"
        case .detailAttempt(let id): "/api/v1/attempts/\(id)"
        case .delete(let id): "/api/v1/attempts/\(id)"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .attempts, .detailAttempt: .get
        case .delete: .delete
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .attempts, .detailAttempt, .delete: nil
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .attempts, .detailAttempt, .delete: nil
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .attempts, .detailAttempt, .delete: nil
        }
    }
}
