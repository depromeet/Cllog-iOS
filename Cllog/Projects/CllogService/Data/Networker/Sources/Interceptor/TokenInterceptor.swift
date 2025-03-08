//
//  TokenInterceptor.swift
//  Networker
//
//  Created by soi on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Starlink

public class TokenInterceptor: StarlinkInterceptor{
    let token: TokenDTO
    
    public init(token: TokenDTO) {
        self.token = token
    }
    
    public func adapt(_ urlRequest: inout URLRequest) async throws -> URLRequest {
        urlRequest.setValue(
            token.accessToken,
            forHTTPHeaderField: "Authorization"
        )
        return urlRequest
    }
}
