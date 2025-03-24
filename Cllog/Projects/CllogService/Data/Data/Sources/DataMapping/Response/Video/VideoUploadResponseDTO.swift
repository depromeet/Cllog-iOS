//
//  VideoUploadResponseDTO.swift
//  Data
//
//  Created by saeng lin on 3/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import VideoDomain

public struct VideoUploadResponseDTO: Codable {
    public let storyId: Int
    public let problemId: Int
    
    func toDomain() -> VideoUploadModel {
        return .init(storyId: storyId, problemId: problemId)
    }
}
