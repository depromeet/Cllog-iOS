//
//  CapturePermissionable.swift
//  CaptureFeatureInterface
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol CapturePermissionable: Sendable {
    func isPermission() async -> Bool
    func requestPermission() async throws
}
