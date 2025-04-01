//
//  VideoPermissionUseCase.swift
//  VideoDomain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

import Shared

import Dependencies
import Photos

public enum VideoPermissionError: Error {
    case unknown
    case denied
}

public protocol VideoPermissionUseCase: Sendable {
    func execute() async throws
}

public struct VideoPermission: VideoPermissionUseCase {
    
    public init() {}
    
    public func execute() async throws {
        try await checkVideoPermission()
        try await checkMicrophonePermission()
        try await checkPhotoLibraryPermission()
    }
    
    private func checkVideoPermission() async throws {
        let currentStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if currentStatus == .authorized {
            return
        }
        
        try await withCheckedThrowingContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    print("✅ 카메라 권한 허용")
                    continuation.resume(returning: ())
                } else {
                    print("❌ 카메라 권한 없음")
                    continuation.resume(throwing: VideoPermissionError.denied)
                }
            }
        }
    }
    
    private func checkMicrophonePermission() async throws {
        
        if AVAudioApplication.shared.recordPermission == .granted {
            return
        }
        try await withCheckedThrowingContinuation { continuation in
            AVAudioApplication.requestRecordPermission(completionHandler: { granted in
                if granted {
                    print("✅ 마이크 권한 허용")
                    continuation.resume()
                } else {
                    print("❌ 마이크 권한 없음")
                    continuation.resume(throwing: VideoPermissionError.denied)
                }
            })
        }
    }
    
    private func checkPhotoLibraryPermission() async throws {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            print("✅ 사진첩 권한 허용됨")
            return
        case .restricted, .denied, .notDetermined:
            print("❌ 사진 라이브러리 권한 없음")
            throw VideoPermissionError.denied
        @unknown default:
            break
        }
    }
}

public struct MockVideoPermission: VideoPermissionUseCase {
    public func execute() async throws {
        
    }
}

public enum VideoPermissionDepdencyKey: DependencyKey {
    public static var liveValue: any VideoPermissionUseCase = VideoPermission()
    public static var testValue: any VideoPermissionUseCase = MockVideoPermission()
    public static var previewValue: any VideoPermissionUseCase = MockVideoPermission()
}

public extension DependencyValues {
    var videoPermission: any VideoPermissionUseCase {
        get { self[VideoPermissionDepdencyKey.self] }
        set { self[VideoPermissionDepdencyKey.self] = newValue }
    }
}
