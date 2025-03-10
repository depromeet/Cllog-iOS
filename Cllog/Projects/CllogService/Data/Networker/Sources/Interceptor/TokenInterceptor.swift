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
    private let tokenProvider: () -> TokenDTO?
    
    public init(provider: @escaping () -> TokenDTO?) {
        tokenProvider = provider
    }
    
    public func adapt(_ urlRequest: inout URLRequest) async throws -> URLRequest {
        guard let token = tokenProvider() else {
            return urlRequest
        }
        
        var request = urlRequest
        request.setHeader(.init(name: "Authorization", value: token.accessToken))
        request.setHeader(.init(name: "Provider", value: token.provider))
        return request
    }
}
