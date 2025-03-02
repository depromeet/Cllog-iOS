//
//  EndpointType.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Starlink

// TODO: Encodable Parameter
protocol EndpointType {
    var baseURL: String { get }
    var path: String { get }
    var method: Starlink.Method { get }
    var parameters: Starlink.SafeDictionary<String, Any>? { get }
    var headers: [Starlink.Header]? { get }
}
