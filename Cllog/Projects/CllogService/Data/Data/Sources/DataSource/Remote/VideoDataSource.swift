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
    func uploadThumbnail(name: String, fileName: String, min: String, data: Data) async throws -> VideoThumbnailUploadResponseDTO
    
    func videoUpload(_ request: VideoUploadRequestDTO) async throws -> VideoUploadResponseDTO
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
    ) async throws -> VideoThumbnailUploadResponseDTO {
        
        let response: BaseResponseDTO<VideoThumbnailUploadResponseDTO> = try await videoProvider.uploadRequest(VideoEndPoint.uploadThumbnail, .init(
            name: name,
            fileName: fileName,
            data: data,
            mimeType: min
        ))

        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return data
    }
    
    /// 비디오 업로드 -
    /// - Parameter request: 요청 파라미터
    /// - Returns: Response
    public func videoUpload(
        _ request: VideoUploadRequestDTO
    ) async throws -> VideoUploadResponseDTO {
        let response: BaseResponseDTO<VideoUploadResponseDTO> = try await authProvider.request(VideoEndPoint.uploadVideo(request))
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        return data
    }
    
    
}

public enum VideoEndPoint: EndpointType {
    case uploadThumbnail
    case uploadVideo(VideoUploadRequestDTO)
    
    public var baseURL: String {
        return Environment.baseURL
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
            return .post
        }
    }
    
    public var parameters: ParameterType? {
        switch self {
        case .uploadThumbnail:
            return .encodable(EmptyModel())
            
        case .uploadVideo:
            return nil
        }
    }
    public var encodable: (any Encodable)? {
        switch self {
        case .uploadThumbnail:
            return nil
            
        case .uploadVideo(let videoUploadRequestDTO):
            return videoUploadRequestDTO
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

struct EmptyModel: Encodable {}
