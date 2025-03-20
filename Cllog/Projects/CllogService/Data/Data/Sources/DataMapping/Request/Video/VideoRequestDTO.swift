//
//  VideoRequestDTO.swift
//  Data
//
//  Created by lin.saeng on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct VideoUploadDTO: Encodable {
    let fileName: String
    
    public init(
        fileName: String
    ) {
        self.fileName = fileName
    }
}
