//
//  VideoRepository.swift
//  VideoDomain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol VideoRepository: Sendable {
    
    /// 영상을 업로드 하는 인터페이스
    func uploadVideo() async throws
}
