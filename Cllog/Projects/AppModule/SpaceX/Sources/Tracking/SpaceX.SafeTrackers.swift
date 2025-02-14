//
//  SpaceX.SafeTrackers.swift
//  SpaceX
//
//  Created by saeng lin on 2/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

extension SpaceX {

    final class SafeTrackers: @unchecked Sendable {
        
        private let lock = SpaceXRWLock()
        private var trackers: [any SpaceXTracking] = []
        
        init() {}
        
        func append(_ newTrackers: [any SpaceXTracking]) {
            lock.write { trackers.append(contentsOf: newTrackers) }
        }
        
        func allTrackers() -> [any SpaceXTracking] {
            lock.read { trackers }
        }
    }
}
