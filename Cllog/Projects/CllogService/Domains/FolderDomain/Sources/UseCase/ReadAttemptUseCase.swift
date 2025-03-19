//
//  ReadAttemptUseCase.swift
//  FolderDomain
//
//  Created by soi on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol ReadAttemptUseCase {
    func getAttempt() async throws -> Attempt
}
