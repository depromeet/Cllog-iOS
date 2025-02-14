//
//  ThreadSafeDictionary.swift
//  SpaceX
//
//  Created by saeng lin on 2/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

extension SpaceX {

    public final class SafeDictionary<Key: Hashable, Value> {
        private var storage: [Key: Value] = [:]
        private let lock = SpaceXRWLock()
        
        public init(storage: [Key: Value] = [:]) {
            self.storage = storage
        }
        
        public subscript(key: Key) -> Value? {
            get { lock.read { storage[key]}}
            set { lock.write { storage[key] = newValue } }
        }
        
        public func forEach(_ callback: (Key, Value) throws -> Void) rethrows {
            try lock.read { try storage.forEach(callback) }
        }
    }

}
