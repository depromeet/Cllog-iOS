//
//  CaptureUseCase.swift
//  CaptureDomain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol CaptureUseCase: Sendable {
    func execute(fileURL: URL) async throws
}

public struct CaptureUploadUsesCase {
    
    private let capturerepository: CaptureRepository
    
    /// 초기화
    /// - Parameter capturerepository: 영상촬영 - Repository 주입
    public init(capturerepository: CaptureRepository) {
        self.capturerepository = capturerepository
    }
}

extension CaptureUploadUsesCase: CaptureUseCase {
    public func execute(fileURL: URL) async throws {
        return try await capturerepository.uploadCapture(fileURL: fileURL)
    }
}
