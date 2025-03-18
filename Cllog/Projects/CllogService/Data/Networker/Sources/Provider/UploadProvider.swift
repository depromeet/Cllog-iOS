//
//  UploadProvider.swift
//  Networker
//
//  Created by lin.saeng on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink
import Pulse
//
//public final class UploadProvider: UploadProviderable, Sendable {
//    
//    private let tokenInterceptor: TokenInterceptor
//    
//    public init(tokenProvider: @escaping @Sendable () -> TokenDTO?) {
//        self.tokenInterceptor = TokenInterceptor(provider: tokenProvider)
//    }
//    
//    public func upload<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
//        let url = endpoint.baseURL + endpoint.path
//        
//        let configure = Starlink.default()
//        let session = URLSessionProxy(configuration: .default, delegate: configure.delegate)
//        
//        let request = Starlink.init(
//            session: session,
//            interceptors:[
//                    AppIntoInterceptor(),
//                    tokenInterceptor
//                ]
//        ).request(
//            url,
//            params: endpoint.parameters,
//            method: endPoint.method,
//            headers: endPoint.headers ?? [],
//            encoding: endPoint.encoding
//        )
//    }
//    
//    public func request<T: Decodable>(_ endpoint: any EndpointType) async throws -> T {
//        let url = endpoint.baseURL + endpoint.path
//        
//        let configure = Starlink.default()
//        let session = URLSessionProxy(configuration: .default, delegate: configure.delegate)
//        
//        let reqeust = switch endpoint.parameters {
//        case .none:
//            request(
//                url: url,
//                endPoint: endpoint,
//                session: session,
//                interceptors: [
//                    AppIntoInterceptor(),
//                    tokenInterceptor
//                ]
//            )
//            
//        case .some(let type):
//            switch type {
//            case .dictionary(let parameters):
//                request(
//                    url: url,
//                    endPoint: endpoint,
//                    session: session,
//                    parameters: parameters,
//                    interceptors: [
//                        AppIntoInterceptor(),
//                        tokenInterceptor
//                    ]
//                )
//            case .encodable(let parameters):
//                request(
//                    url: url,
//                    endPoint: endpoint,
//                    session: session,
//                    parameters: parameters,
//                    interceptors: [
//                        AppIntoInterceptor(),
//                        tokenInterceptor
//                    ]
//                )
//            }
//        }
//        
//        let response: T = try await reqeust.reponseAsync()
//        
//        return response
//    }
//}
