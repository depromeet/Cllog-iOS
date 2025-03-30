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
    func uploadThumbnail(fileName: String, mimeType: String, data: Data) async throws -> VideoThumbnailUploadResponseDTO
}

public struct VideoDataSource: VideoDataSourceLogic {
    
    private let videoProvider: UploadProvider
    private let authProvider: AuthProvider
    
    public init(videoProvider: UploadProvider, authProvider: AuthProvider) {
        self.videoProvider = videoProvider
        self.authProvider = authProvider
    }
    
    public func uploadThumbnail(
        fileName: String,
        mimeType: String,
        data: Data
    ) async throws -> VideoThumbnailUploadResponseDTO {
        
        let response: BaseResponseDTO<VideoThumbnailUploadResponseDTO> = try await videoProvider.uploadRequest(VideoEndPoint.uploadThumbnail, .init(
            name: "file",
            fileName: fileName,
            data: data,
            mimeType: mimeType
        ))

        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return data
    }
    
}

public enum VideoEndPoint: EndpointType {
    case uploadThumbnail
    
    public var baseURL: String {
        return Environment.baseURL
    }
    public var path: String {
        switch self {
        case .uploadThumbnail:
            return "/api/v1/thumbnails/upload"
        }
    }
    
    public var method: Starlink.Method {
        switch self {
        case .uploadThumbnail:
            return .post
        }
    }
    
    public var parameters: ParameterType? {
        switch self {
        case .uploadThumbnail:
            return .encodable(EmptyModel())
        }
    }
    public var encodable: (any Encodable)? {
        switch self {
        case .uploadThumbnail:
            return nil
        }
    }
    public var headers: [Starlink.Header]? { nil }
    
    public var encoding: StarlinkEncodable {
        switch self {
        case .uploadThumbnail:
            return Starlink.StarlinkJSONEncoding()
        }
    }
}

struct EmptyModel: Encodable {}
