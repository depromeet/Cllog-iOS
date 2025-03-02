//
//  LoginAPI.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink

enum LoginAPI {
    case kakaoLogin(idToken: String)
    case appleLogin(code: String, codeVerifier: String)
}

extension LoginAPI: EndpointType {
    var baseURL: String {
        "https://dev-api.climb-log.my/api/v1"
    }
    
    var path: String {
        switch self {
        case .kakaoLogin: "/auth/kakao"
        case .appleLogin: "/auth/apple"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .kakaoLogin: .post
        case .appleLogin: .post
        }
    }
    
    var parameters: ParameterType? {
        switch self {
        case .kakaoLogin(let idToken):
                .dictionary(Starlink.SafeDictionary<String, Any>(storage: ["id_token": idToken]))
        case .appleLogin(let code, let codeVerifier):
                .encodable(AuthTokenRequestDTO(code: code, codeVerifier: codeVerifier))
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .kakaoLogin: nil
        case .appleLogin(let code, let codeVerifier):
            AuthTokenRequestDTO(code: code, codeVerifier: codeVerifier)
        }
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
}

