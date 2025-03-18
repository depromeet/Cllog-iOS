//
//  CragDataSource.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Starlink
import Networker

public protocol CragDataSource {
    func crags() async throws -> [FolderCragResponseDTO]
}

public final class DefaulCragDataSource: CragDataSource {
   
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func crags() async throws -> [FolderCragResponseDTO] {
        let response: BaseResponseWithMetaDTO<FolderAttemptCragResponseDTO, BaseMetaResponseDTO> = try await provider.request(
            CragTarget.myCrags
        )
        
        guard let crags = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return crags.contents ?? []
    }
    
}

enum CragTarget {
    case myCrags
}

extension CragTarget: EndpointType {
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkURLEncoding()
    }
    
    var baseURL: String {
        "https://dev-api.climb-log.my"
    }
    
    var path: String {
        switch self {
        case .myCrags: "/api/v1/crags/me"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .myCrags: .get
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .myCrags: nil
        }
    }
    
    var encodable: (any Encodable)? {
        switch self {
        case .myCrags: nil
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .myCrags: nil
        }
    }
    
    
}
