//
//  VideoRecordRepositry.swift
//  Data
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import VideoDomain

import Networker
import Starlink
import Swinject

public struct VideoRecordRepositry: VideoRepository {

    private let provider: Networker.Provider
    
    public init(
        provider: Networker.Provider
    ) {
        self.provider = provider
    }
    
    public func uploadVideo(fileURL: URL) async throws {
        let model: Emtpy = try await provider.request(VideoTarget())
    }
}

struct Emtpy: Decodable {
    
}
