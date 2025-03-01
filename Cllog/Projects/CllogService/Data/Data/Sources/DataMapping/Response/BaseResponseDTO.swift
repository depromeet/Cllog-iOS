//
//  BaseResponseDTO.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// FIXME: 서버에서 error 및 success 제거 시 수정 필요
struct BaseResponseDTO<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: ErrorResponseDTO?
}
