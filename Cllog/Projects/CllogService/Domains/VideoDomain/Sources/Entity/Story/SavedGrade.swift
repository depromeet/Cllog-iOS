//
//  SavedGrade.swift
//  VideoDomain
//
//  Created by soi on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct SavedGrade: Codable {
    let id: Int
    let name: String
    let hexCode: String
    
    public init(id: Int, name: String, hexCode: String) {
        self.id = id
        self.name = name
        self.hexCode = hexCode
    }
}
