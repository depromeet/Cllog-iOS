//
//  SpaceX.Configure.swift
//  SpaceXTests
//
//  Created by saeng lin on 1/27/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

public protocol SpaceXConfiguration: Sendable {
    var queue: OperationQueue? { get }
    var delegate: URLSessionDelegate? { get }
    func configure() -> URLSessionConfiguration
}

extension SpaceXConfiguration {
    public var queue: OperationQueue? { nil }
    public var delegate: URLSessionDelegate? { nil }
}

public extension SpaceX {
    
    struct `default`: SpaceXConfiguration {
        
        public init() {}
        
        public func configure() -> URLSessionConfiguration {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 60
            configuration.timeoutIntervalForResource = 60
            return configuration
        }
    }
}
