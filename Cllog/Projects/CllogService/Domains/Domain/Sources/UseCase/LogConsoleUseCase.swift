//
//  LogUseCase.swift
//  Domain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol LogConsoleUseCase {
    func executeInfo(label: String, message: String)
    func executeDebug(label: String, message: String)
}
