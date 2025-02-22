//
//  ClLogCapture+Enter.swift
//  ClLogCaptureFeature
//
//  Created by saeng lin on 2/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit

import ClLogCaptureFeatureInterface

public struct ClLogCaptureEnter: ClLogCaptureEnterLogic {
    
    public init() {}
    
    @MainActor
    public func start(on: UIViewController) async throws {
        return try await ClLogCaptureViewController.start(on: on)
    }
}
