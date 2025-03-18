//
//  VideoUploadResponseDTO.swift
//  Data
//
//  Created by saeng lin on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import VideoDomain


public struct VideoUploadResponseDTO: Codable {
    public let fileUrl: String
    
    public init(fileUrl: String) {
        self.fileUrl = fileUrl
    }
    
    func toDomain() -> Videothumbnails {
        return Videothumbnails(fileUrl: fileUrl)
    }
}
