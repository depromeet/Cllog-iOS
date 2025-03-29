//
//  VideoUseCase.swift
//  VideoDomain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Shared

import Dependencies

public enum VideoError: Error {
    // 공통 에러
    case unknown
    case saveFailed
    
    // 파일 매니저 에러
    case notFoundDirectory
    case notFoundFile
    case readFailed
    
    // 사진앱 저장 실패 에러
    case savePhotoDenied
    case notFoundAsset
}

public protocol VideoUseCase: Sendable {
    func execute(saveFile fileURL: URL) async throws -> String
    func execute(loadName: String) async throws -> URL
    
    func execute(name: String, fileName: String, mimeType: String, value: Data) async throws -> Videothumbnails
}

public struct VideoUploadUsesCase {
    
    private let videoRepository: VideoRepository
    
    /// 초기화
    /// - Parameter capturerepository: 영상촬영 - Repository 주입
    public init(videoRepository: VideoRepository) {
        self.videoRepository = videoRepository
    }
}

extension VideoUploadUsesCase: VideoUseCase {
    public func execute(saveFile fileURL: URL) async throws -> String {
        do {
            return try await videoRepository.saveVideo(fileURL: fileURL)
        } catch {
            print("비디오 업로드 에러:\(error)")
            throw VideoError.unknown
        }
    }
    
    public func execute(loadName: String) async throws -> URL {
        try await videoRepository.readSavedVideo(fileName: loadName)
    }
    
    public func execute(name: String, fileName: String, mimeType: String, value: Data) async throws -> Videothumbnails {
        try await videoRepository.uploadVideoThumbnail(name: name, fileName: fileName, min: mimeType, value: value)
    }
//
//    public func execute(
//        name: String, fileName: String, mimeType: String, value: Data
//    ) async throws -> VideoUploadModel {
//        // 썸네일 업로드
//        
//        // 비디오 업로드
//    }
}

public enum VideoUploadUsesCaseDepdencyKey: DependencyKey {
    public static var liveValue: any VideoUseCase = VideoUploadUsesCase(videoRepository: ClLogDI.container.resolve(VideoRepository.self)!)
}

public extension DependencyValues {
    var videoUseCase: any VideoUseCase {
        get { self[VideoUploadUsesCaseDepdencyKey.self] }
        set { self[VideoUploadUsesCaseDepdencyKey.self] = newValue }
    }
}
