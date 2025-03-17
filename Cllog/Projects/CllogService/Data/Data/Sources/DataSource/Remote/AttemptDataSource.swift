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
}

enum AttemptTarget {
    case attempts
}

extension AttemptTarget: EndpointType {
   
    var baseURL: String {
        return "https://dev-api.climb-log.my"
    }
    
    var path: String {
        switch self {
        case .attempts: "/api/v1/attempts"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .attempts: .get
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .attempts: nil
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .attempts: nil
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .attempts: nil
        }
    }
}
