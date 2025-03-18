//
//  UploadProvider.swift
//  Networker
//
//  Created by lin.saeng on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink
import Pulse

import Foundation

public final class UploadProvider: UploadProviderable, Sendable {
    
    private let tokenInterceptor: TokenInterceptor
    
    public init(tokenProvider: @escaping @Sendable () -> TokenDTO?) {
        self.tokenInterceptor = TokenInterceptor(provider: tokenProvider)
    }
    
    public func upload<T: Decodable>(
        _ endpoint: EndpointType,
        _ uploadData: UploadDataForm
    ) async throws -> T {
        let url = endpoint.baseURL + endpoint.path
        
        let configure = Starlink.default()
        let session = URLSessionProxy(configuration: .default, delegate: configure.delegate)
        
        switch endpoint.parameters {
        case .none:
            return try await Starlink.init(
                session: session,
                interceptors: [
                    AppInfoInterceptor(),
                    tokenInterceptor
                ]
            )
            .uploadResponse(url, encodable: nil, method: .post, uploadForm: uploadData)
            
        case .some(let type):
            switch type {
            case .dictionary(let parameters):
                return try await Starlink.init(
                    session: session,
                    interceptors: [
                        AppInfoInterceptor(),
                        tokenInterceptor
                    ]
                )
                .uploadResponse(url, encodable: nil, method: .post, uploadForm: uploadData)
                
            case .encodable(let parameters):
                return try await Starlink.init(
                    session: session,
                    interceptors: [
                        AppInfoInterceptor(),
                        tokenInterceptor
                    ]
                ).uploadResponse(url, encodable: parameters, method: .post, uploadForm: uploadData)
            }
        }
    }
}
