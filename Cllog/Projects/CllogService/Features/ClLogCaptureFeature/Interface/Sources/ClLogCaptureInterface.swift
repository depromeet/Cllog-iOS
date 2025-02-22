//
//  ClLogCaptureInterface.swift
//  ClLogCaptureFeature
//
//  Created by saeng lin on 2/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit

public protocol ClLogCaptureInterface {
    
    var enter: ClLogCaptureEnterLogic { get async  }
    
    var permission: ClLogCpaturePermissionLogic { get async }
}

public protocol ClLogCaptureEnterLogic {
    
    /// 카메라 화면 진입
    /// - Parameter on: owner
    @MainActor
    func start(on: UIViewController) async throws
}

public protocol ClLogCpaturePermissionLogic {
    
    func checkVideos() async throws
}
