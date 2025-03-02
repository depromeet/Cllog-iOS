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
    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
        let url = endpoint.baseURL + endpoint.path
        
        let reqeust = switch endpoint.parameters {
        case .none:
            request(url: url, endPoint: endpoint)
            
        case .some(let type):
            switch type {
                
            case .dictionary(let parameters):
                request(url: url, endPoint: endpoint, parameters: parameters)
                
            case .encodable(let parameters):
                request(url: url, endPoint: endpoint, parameters: parameters)
            }
        }
        
        let response: BaseResponseDTO<T> = try await reqeust.reponseAsync()
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return data
    }
    
    private func request(
        url: String,
        endPoint: EndpointType,
        parameters: Starlink.SafeDictionary<String, Any>? = nil
    ) -> StarlinkRequest {
        return Starlink.session.request(
            url,
            params: parameters,
            method: endPoint.method,
            headers: endPoint.headers ?? []
        )
    }
    
    private func request(
        url: String,
        endPoint: EndpointType,
        parameters: Encodable
    ) -> StarlinkRequest {
        return Starlink.session.request(
            url,
            encodable: parameters,
            method: endPoint.method,
            headers: endPoint.headers ?? []
        )
    }
}
