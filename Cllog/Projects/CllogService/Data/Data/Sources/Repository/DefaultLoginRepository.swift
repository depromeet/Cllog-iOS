//
//  DefaultLoginRepository.swift
//  Data
//
//  Created by soi on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import LoginDomain
import Starlink

public struct DefaultLoginRepository: LoginRepository {
    
    public init() {}
    
    public func login(_ idToken: String) async throws {
        let url = "https://dev-api.climb-log.my/api/v1/auth/kakao"
        
        do {
            let response: BaseResponseDTO<AuthTokenResponseDTO> = try await
            // FIXME: params 변경
            Starlink.session.request(
                url,
                params: Starlink.SafeDictionary<String, Any>(storage: ["id_token": idToken]),
                method: .post
            )
            .reponseAsync()
            // TODO: Access Token keychain 저장
            guard let token = response.data else {
                throw StarlinkError.inValidJSONData(.none)
            }
            print("✅ access token", token.accessToken)
            print("✅ refresh token", token.refreshToken)
            
        } catch {
            throw error
        }
    }
}
