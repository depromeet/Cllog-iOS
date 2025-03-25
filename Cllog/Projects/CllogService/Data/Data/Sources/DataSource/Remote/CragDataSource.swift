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
    func myCrags() async throws -> [FolderCragResponseDTO]
    func nearByCrags(longitude: Double, latitude: Double) async throws -> [FolderCragResponseDTO]
}

public final class DefaultCragDataSource: CragDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func myCrags() async throws -> [FolderCragResponseDTO] {
        let response: BaseResponseDTO<BaseContentsResponse<[FolderCragResponseDTO], BaseMetaResponseDTO>> = try await provider.request(
            CragTarget.myCrags
        )
        
        guard let crags = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return crags.contents
    }
    
    public func nearByCrags(longitude: Double, latitude: Double) async throws -> [FolderCragResponseDTO] {
        let response: BaseResponseDTO<BaseContentsResponse<[FolderCragResponseDTO], BaseMetaResponseDTO>> = try await provider.request(CragTarget.nearBy(longitude: longitude, latitude: latitude))
        
        guard let crags = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return crags.contents
    }
    
}

enum CragTarget {
    case myCrags
    case nearBy(longitude: Double, latitude: Double)
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
        case .nearBy: "/api/v1/crags/nearby"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .myCrags, .nearBy: .get
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .myCrags: return nil
        case .nearBy(let longitude, let latitude):
            let dictionary = Starlink.SafeDictionary<String, Any>(
                storage: [
                    "longitude": longitude,
                    "latitude" : latitude,
                ]
            )
            return Networker.ParameterType.dictionary(dictionary)
        }
    }
    
    var encodable: (any Encodable)? {
        switch self {
        case .myCrags, .nearBy: nil
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .myCrags, .nearBy: nil
        }
    }
}
