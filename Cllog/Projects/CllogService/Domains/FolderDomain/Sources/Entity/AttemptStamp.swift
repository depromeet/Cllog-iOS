//
//  AttemptStamp.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// TODO: Stroy Stamp와 동일
public struct AttemptStamp: Hashable, Equatable {
    public let id: Int
    public let timeMs: Int
    
    public init(
        id: Int,
        timeMs: Int
    ) {
        self.id = id
        self.timeMs = timeMs
    }
}
