//
//  Attempt.swift
//  FolderDomain
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct Attempt: Hashable, Identifiable {
    public var id = UUID()
    
    public let date: String
    public let grade: Grade?
    public let result: AttemptResult
    public let recordedTime: String
    public let crag: Crag?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
