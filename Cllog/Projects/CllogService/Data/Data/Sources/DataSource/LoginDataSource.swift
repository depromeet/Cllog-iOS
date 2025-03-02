//
//  LoginDataSource.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink
import Networker

public protocol LoginDataSource {
    func kakaoLogin(idToken: String) async throws -> AuthTokenResponseDTO
    func appleLogin(code: String, codeVerifier: String) async throws -> AuthTokenResponseDTO
}

public final class DefaultLoginDataSource: LoginDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func kakaoLogin(idToken: String) async throws-> AuthTokenResponseDTO {
        let response: BaseResponseDTO<AuthTokenResponseDTO> = try await provider.request(
            LoginTarget.kakaoLogin(idToken: idToken)
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
        
    }
    
    public func appleLogin(code: String, codeVerifier: String) async throws -> AuthTokenResponseDTO {
        let response: BaseResponseDTO<AuthTokenResponseDTO> = try await provider.request(
            LoginTarget.appleLogin(code: code, codeVerifier: codeVerifier)
        )
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }
}

enum LoginTarget {
    case kakaoLogin(idToken: String)
    case appleLogin(code: String, codeVerifier: String)
}

extension LoginTarget: EndpointType {
    var baseURL: String {
        "https://dev-api.climb-log.my/api"
    }
    
    var path: String {
        switch self {
        case .kakaoLogin: "/v1/auth/kakao"
        case .appleLogin: "/v1/auth/apple"
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
