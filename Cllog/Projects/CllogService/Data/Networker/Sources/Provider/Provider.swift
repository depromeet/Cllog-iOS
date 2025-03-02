//
//  Provider.swift
//  Networker
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink

public protocol Provider {
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T
}

extension Provider {
    func request(
        url: String,
        endPoint: EndpointType,
        session: Sessionable,
        parameters: Starlink.SafeDictionary<String, Any>? = nil
    ) -> StarlinkRequest {
        return Starlink.init(session: session).request(
            url,
            params: parameters,
            method: endPoint.method,
            headers: endPoint.headers ?? []
        )
    }
    
    func request(
        url: String,
        endPoint: EndpointType,
        session: Sessionable,
        parameters: Encodable
    ) -> StarlinkRequest {
        return Starlink.init(session: session).request(
            url,
            encodable: parameters,
            method: endPoint.method,
            headers: endPoint.headers ?? []
        )
    }
}
