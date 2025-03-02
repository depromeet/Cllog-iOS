//
//  LoginDataSource.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink
import Networker

public protocol AuthDataSource {
    func kakaoLogin(idToken: String) async throws -> AuthTokenResponseDTO
    func appleLogin(code: String, codeVerifier: String) async throws -> AuthTokenResponseDTO
}

public final class DefaultAuthDataSource: AuthDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func kakaoLogin(idToken: String) async throws-> AuthTokenResponseDTO {
        let request = KakaoLoginReqeustDTO(idToken: idToken)
        
        let response: BaseResponseDTO<AuthTokenResponseDTO> = try await provider.request(
            LoginTarget.kakaoLogin(request)
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
        
    }
    
    public func appleLogin(code: String, codeVerifier: String) async throws -> AuthTokenResponseDTO {
        let request = ApleLoginRequestDTO(code: code, codeVerifier: codeVerifier)
        
        let response: BaseResponseDTO<AuthTokenResponseDTO> = try await provider.request(
            LoginTarget.appleLogin(request)
        )
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }
}

enum LoginTarget {
    case kakaoLogin(KakaoLoginReqeustDTO)
    case appleLogin(ApleLoginRequestDTO)
}

extension LoginTarget: EndpointType {
    var baseURL: String {
        return "https://dev-api.climb-log.my"
    }
    
    var path: String {
        switch self {
        case .kakaoLogin: 
            return "/api/v1/auth/kakao"
        case .appleLogin:
            return "/api/v1/auth/apple"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .kakaoLogin, .appleLogin:
            return .post
        }
    }
    
    var parameters: ParameterType? {
        switch self {
        case .kakaoLogin(let request):
            return .encodable(request)
        case .appleLogin(let request):
            return .encodable(request)
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .kakaoLogin(let request):
            return request
        case .appleLogin(let request):
            return request
        }
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
}
