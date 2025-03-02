//
//  AuthTokenResponseDTO.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct AuthTokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
