//
//  CapturePermission.swift
//  CaptureFeatureInterface
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

import CaptureFeatureInterface

import Dependencies

private enum CapturePermissionKey: DependencyKey {
    static let liveValue: any CapturePermissionable = CapturePermission()
}

extension DependencyValues {
    
    var capturePermissionable: any CapturePermissionable {
        get { self[CapturePermissionKey.self] }
        set { self[CapturePermissionKey.self] = newValue }
    }
}


struct CapturePermission: CapturePermissionable {
    
    func isPermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return status == .authorized
    }
    
    func requestPermission() async throws {

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
                        domain: "CapturePermission",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: "Camera permission denied."]
                    )
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
