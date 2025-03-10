//
//  VideoUseCase.swift
//  VideoDomain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol VideoUseCase: Sendable {
    func execute(fileURL: URL) async throws
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
    public func execute(fileURL: URL) async throws {
        return try await videoRepository.uploadVideo(fileURL: fileURL)
    }
}
