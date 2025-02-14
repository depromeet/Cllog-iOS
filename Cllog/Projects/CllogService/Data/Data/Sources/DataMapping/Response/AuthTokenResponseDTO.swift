//
//  AuthTokenResponseDTO.swift
//  Data
//
//  Created by soi on 2/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct AuthTokenResponseDTO: Decodable {
    let acceessToken: String
    let refreshToken: String
    let expiredDate: String
}
