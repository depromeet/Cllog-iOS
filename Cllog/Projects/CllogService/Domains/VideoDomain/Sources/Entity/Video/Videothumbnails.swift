//
//  Videothumbnails.swift
//  VideoDomain
//
//  Created by saeng lin on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Videothumbnails: Codable {
    public let fileUrl: String
    
    public init(fileUrl: String) {
        self.fileUrl = fileUrl
    }
}
