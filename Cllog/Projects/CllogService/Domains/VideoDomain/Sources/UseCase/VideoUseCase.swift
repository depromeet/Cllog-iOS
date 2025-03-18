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

public protocol VideoUseCase: Sendable {
    func execute(saveFile fileURL: URL) async throws
    func execute(loadName: String) async throws -> URL?
    
    func execute(name: String, fileName: String, min: String, value: Data) async throws -> Videothumbnails
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
    public func execute(saveFile fileURL: URL) async throws {
        try await videoRepository.saveVideo(fileURL: fileURL)
//        try await videoRepository.uploadVideo(fileURL: fileURL)
    }
    
    public func execute(loadName: String) async throws -> URL? {
        try await videoRepository.readSavedVideo(fileName: loadName)
    }
    
    public func execute(name: String, fileName: String, min: String, value: Data) async throws -> Videothumbnails {
        try await videoRepository.uploadVideoThumbnail(name: name, fileName: fileName, min: min, value: value)
    }
}

public enum VideoUploadUsesCaseDepdencyKey: DependencyKey {
    public static var liveValue: any VideoUseCase = VideoUploadUsesCase(videoRepository: ClLogDI.container.resolve(VideoRepository.self)!)
}

public extension DependencyValues {
    var videoUsecase: any VideoUseCase {
        get { self[VideoUploadUsesCaseDepdencyKey.self] }
        set { self[VideoUploadUsesCaseDepdencyKey.self] = newValue }
    }
}
