//
//  TokenDTO.swift
//  Networker
//
//  Created by soi on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct TokenDTO {
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    let accessToken: String
    let refreshToken: String
}
