//
//  Level.swift
//  Domain
//
//  Created by soi on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Level {
    public let name: String
    public let colorCode: Int
    
    public init(name: String, colorCode: Int) {
        self.name = name
        self.colorCode = colorCode
    }
}
