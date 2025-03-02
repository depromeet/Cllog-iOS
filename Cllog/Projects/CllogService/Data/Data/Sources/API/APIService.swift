//
//  APIService.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink

final class APIService {
    static let shared = APIService()
    
    private init() {}
    
    // TODO: encodable 적용
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
        let url = endpoint.baseURL + endpoint.path
        
        let response: BaseResponseDTO<T> = try await
        Starlink.session.request(
            url,
            params: endpoint.parameters,
            method: endpoint.method
        )
        .reponseAsync()
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return data
    }
}
