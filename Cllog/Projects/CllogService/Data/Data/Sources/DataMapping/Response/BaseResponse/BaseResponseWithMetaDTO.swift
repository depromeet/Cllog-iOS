//
//  BaseResponseWithMetaDTO.swift
//  Data
//
//  Created by soi on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct BaseResponseWithMetaDTO<T: Decodable, M: Decodable>: Decodable {
    let data: T?
    let meta: M
}
