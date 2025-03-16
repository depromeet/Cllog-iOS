//
//  StoryAttemptStatus.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public enum StoryAttemptStatus: String, Equatable {
    case success = "SUCCESS"
    case failure = "FAILURE"
    
    public init(value: String) {
        self = .init(rawValue: value) ?? .success
    }
}
