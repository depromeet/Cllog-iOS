//
//  VideoDataSource.swift
//  Data
//
//  Created by saeng lin on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Starlink
import Networker

public struct VideoTarget: EndpointType {
    
    public init() {}
    public var baseURL: String {
        return "https://dev-api.climb-log.my"
    }
    public var path: String {
        ""
    }
    
    public var method: Starlink.Method {
        .get
    }
    
    public var parameters: Networker.ParameterType?
    
    public var encodable: (any Encodable)?
    
    public var headers: [Starlink.Header]? {
        return nil
    }
    
    public var encoding: StarlinkEncodable {
        return Starlink.StarlinkURLEncoding()
    }
}
