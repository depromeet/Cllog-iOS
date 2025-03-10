//
//  VideoPermissionUseCase.swift
//  VideoDomain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import AVFoundation

public protocol VideoPermissionUseCase: Sendable {
    func execute() async throws
}

public struct VideoPermission: VideoPermissionUseCase {
    
    public init() {}
    
    public func execute() async throws {
        let currentStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if currentStatus == .authorized {
            return
        }
        
        try await withCheckedThrowingContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    continuation.resume(returning: ())
                } else {
                    let error = NSError(
                        domain: "VideoPermission",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: "Camera permission denied."]
                    )
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
