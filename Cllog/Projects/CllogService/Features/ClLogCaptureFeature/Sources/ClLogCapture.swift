//
//  ClLogCapture.swift
//  ClLogCaptureFeature
//
//  Created by saeng lin on 2/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit

import ClLogCaptureFeatureInterface

public struct ClLogCapture: ClLogCaptureInterface {
    
    public var enter: any ClLogCaptureEnterLogic
    
    public var permission: any ClLogCpaturePermissionLogic
    
    public init(
        enter: any ClLogCaptureEnterLogic = ClLogCaptureEnter(),
        permission: any ClLogCpaturePermissionLogic = ClLogCapturePermission()
    ) {
        self.enter = enter
        self.permission = permission
    }
    
    public func start(on: UIViewController) async throws {
        
        // 비디오 권한 체크
        try await permission.checkVideos()
        
        // 화면 전환
        try await enter.start(on: on)
    }
}
