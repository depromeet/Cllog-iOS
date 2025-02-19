//
//  Configure.swift
//  TossFoundation
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

public protocol StarlinkConfiguration: Sendable {
    var queue: OperationQueue? { get }
    var delegate: URLSessionDelegate? { get }
    func configure() -> URLSessionConfiguration
}

extension StarlinkConfiguration {
    public var queue: OperationQueue? { nil }
    public var delegate: URLSessionDelegate? { nil }
}

public extension Starlink {
    
    struct `default`: StarlinkConfiguration {
        
        public init() {}
        
        public func configure() -> URLSessionConfiguration {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 60
            configuration.timeoutIntervalForResource = 60
            return configuration
        }
    }
}
