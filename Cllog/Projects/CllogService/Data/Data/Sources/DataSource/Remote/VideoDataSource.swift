//
//  VideoDataSource.swift
//  Data
//
//  Created by saeng lin on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Starlink
import Networker

public protocol VideoDataSourceLogic {
    func uploadThumbnail(name: String, fileName: String, min: String, data: Data) async throws
    func uploadVideo() async throws
}

public struct VideoDataSource: VideoDataSourceLogic {
    
    private let provider: Provider
    
    public init(with provider: Provider) {
        self.provider = provider
    }
    
    public func uploadThumbnail(
        name: String,
        fileName: String,
        min: String,
        data: Data
    ) async throws {

    }
    
    public func uploadVideo() async throws {
        
    }
    
    
}

public enum VideoEndPoint: EndpointType {
    case uploadThumbnail
    case uploadVideo
    
    public var baseURL: String {
        return "https://dev-api.climb-log.my"
    }
    public var path: String {
        switch self {
        case .uploadVideo:
            return ""
            
        case .uploadThumbnail:
            return ""
        }
    }
    
    public var method: Starlink.Method {
        switch self {
        case .uploadThumbnail:
            return .post
            
        case .uploadVideo:
            return .get
        }
    }
    
    public var parameters: ParameterType? { nil }
    public var encodable: (any Encodable)? { nil }
    public var headers: [Starlink.Header]? { nil }
    
    public var encoding: StarlinkEncodable {
        switch self {
        case .uploadThumbnail:
            return Starlink.StarlinkJSONEncoding()
            
        case .uploadVideo:
            return Starlink.StarlinkJSONEncoding()
        }
    }
}
