//
//  DefaultLoginRepository.swift
//  Data
//
//  Created by soi on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import LoginDomain
import Alamofire

public struct DefaultLoginRepository: LoginRepository {
    public init() {}
    

    public func login(_ idToken: String) async throws {
        let parameters: [String: String] = [
            "idToken": idToken,
        ]
        
        // Alamofire 요청 보내기
        let url = URL(string: "https://dev-api.climb-log.my/api/v1/auth/kakao")!
        
        // TODO: Starlink로 변경
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: BaseResponseDTO<AuthTokenResponseDTO>.self) {
            response in
            switch response.result {
            case .success(let token):
                guard let data = token.data else { return }
                // TODO: Keychain 저장
                print("access token", data.accessToken)
                print("refresh toekn", data.refreshToken)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
