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
    func uploadThumbnail(name: String, fileName: String, min: String, data: Data) async throws -> VideoUploadResponseDTO
    func uploadVideo() async throws
}

public struct VideoDataSource: VideoDataSourceLogic {
    
    private let videoProvider: UploadProvider
    private let authProvider: AuthProvider
    
    public init(videoProvider: UploadProvider, authProvider: AuthProvider) {
        self.videoProvider = videoProvider
        self.authProvider = authProvider
    }
    
    public func uploadThumbnail(
        name: String,
        fileName: String,
        min: String,
        data: Data
    ) async throws -> VideoUploadResponseDTO {
        let request = VideoUploadDTO(name: name, fileName: fileName, min: min, data: data)
        
        let response: BaseResponseDTO<VideoUploadResponseDTO> = try await videoProvider.upload(VideoEndPoint.uploadThumbnail(request), .init(name: name, fileName: fileName, data: data, mimeType: min))
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return data
    }
    
    public func uploadVideo() async throws {
        
    }
    
    
}

public enum VideoEndPoint: EndpointType {
    case uploadThumbnail(VideoUploadDTO)
    case uploadVideo
    
    public var baseURL: String {
        return "https://dev-api.climb-log.my"
    }
    public var path: String {
        switch self {
        case .uploadVideo:
            return ""
            
        case .uploadThumbnail:
            return "/api/v1/thumbnails/upload"
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
    
    public var parameters: ParameterType? {
        switch self {
        case .uploadThumbnail(let request):
            return .encodable(request)
            
        case .uploadVideo:
            return nil
        }
    }
    public var encodable: (any Encodable)? {
        switch self {
        case .uploadThumbnail(let request):
            return request
            
        case .uploadVideo:
            return nil
        }
    }
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
