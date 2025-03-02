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
}

extension LoginAPI: EndpointType {
    var baseURL: String {
        "https://dev-api.climb-log.my/api/v1"
    }
    
    var path: String {
        switch self {
        case .kakaoLogin: "/auth/kakao"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .kakaoLogin: .post
        }
    }
    
    var parameters: Starlink.SafeDictionary<String, Any>? {
        switch self {
        case .kakaoLogin(let idToken):
            Starlink.SafeDictionary<String, Any>(storage: ["id_token": idToken])
        }
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
}

