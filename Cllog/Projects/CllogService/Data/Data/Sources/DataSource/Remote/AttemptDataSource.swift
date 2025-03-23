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
}

enum AttemptTarget {
    case attempts
    case detailAttempt(id: Int)
}

extension AttemptTarget: EndpointType {
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkURLEncoding()
    }
    
   
    var baseURL: String {
        return Environment.baseURL
    }
    
    var path: String {
        switch self {
        case .attempts: "/api/v1/attempts"
        case .detailAttempt(let id): "/api/v1/attempts/\(id)"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .attempts, .detailAttempt: .get
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .attempts, .detailAttempt: nil
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .attempts, .detailAttempt: nil
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .attempts, .detailAttempt: nil
        }
    }
}
