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
    func patchResult(id: Int, result: String) async throws
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
    
    public func patchResult(id: Int, result: String) async throws {
        let requestDTO = AttemptPatchRequestDTO(status: result)
        let _: EmptyResponseDTO = try await provider.request(
            AttemptTarget.patch(id: id, requestDTO: requestDTO)
        )
    }
    
    public func delete(_ attemptId: Int) async throws {
        let _: EmptyResponseDTO = try await provider.request(AttemptTarget.delete(id: attemptId))
    }
}

enum AttemptTarget {
    case attempts
    case detailAttempt(id: Int)
    case patch(id: Int, requestDTO: AttemptPatchRequestDTO)
    case delete(id: Int)
}

extension AttemptTarget: EndpointType {
    var encoding: any StarlinkEncodable {
        switch self {
        case .patch:
            Starlink.StarlinkJSONEncoding()
        default: Starlink.StarlinkURLEncoding()
        }
    }
    
   
    var baseURL: String {
        return Environment.baseURL
    }
    
    var path: String {
        switch self {
        case .attempts: "/api/v1/attempts"
        case .detailAttempt(let id): "/api/v1/attempts/\(id)"
        case .patch(let id, _): "/api/v1/attempts/\(id)"
        case .delete(let id): "/api/v1/attempts/\(id)"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .attempts, .detailAttempt: .get
        case .patch: .patch
        case .delete: .delete
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .attempts, .detailAttempt, .delete: nil
        case .patch(_, let requestDTO): nil
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .attempts, .detailAttempt, .delete: nil
        case .patch(_, let requestDTO): .encodable(requestDTO)
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .attempts, .detailAttempt, .delete: nil
        case .patch: nil
        }
    }
}
