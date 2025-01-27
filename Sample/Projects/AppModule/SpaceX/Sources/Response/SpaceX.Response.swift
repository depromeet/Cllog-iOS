//
//  SpaceX.Response.swift
//  SpaceXTests
//
//  Created by saeng lin on 1/27/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

public extension SpaceX {
    
    struct Response: Sendable {
        public let response: URLResponse?
        public let data: Data?
        public let error: Error?
        
        let responseTime: Date
        
        init(
            response: URLResponse?,
            data: Data?,
            error: Error?,
            responseTime: Date = Date()
        ) {
            self.response = response
            self.data = data
            self.error = error
            self.responseTime = responseTime
        }
    }
}
