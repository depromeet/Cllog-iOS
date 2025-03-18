//
//  VideoRequestDTO.swift
//  Data
//
//  Created by lin.saeng on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct VideoUploadDTO: Encodable {
    let name: String
    let fileName: String
    let min: String
    let data: Data
    
    public init(
        name: String,
        fileName: String,
        min: String,
        data: Data
    ) {
        self.name = name
        self.fileName = fileName
        self.min = min
        self.data = data
    }
}
