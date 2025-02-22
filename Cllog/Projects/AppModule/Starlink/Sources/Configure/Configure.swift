//
//  Configure.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

import Pulse

public protocol StarlinkConfiguration: Sendable {
    var queue: OperationQueue? { get }
    var delegate: URLSessionDelegate? { get }
    func configure() -> URLSessionConfiguration
}

extension StarlinkConfiguration {
    public var queue: OperationQueue? { nil }
    public var delegate: URLSessionDelegate? { DemoSessionDelegate() }
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

private final class DemoSessionDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        NetworkLogger.shared.logDataTask(dataTask, didReceive: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        NetworkLogger.shared.logTask(task, didFinishCollecting: .init(metrics: metrics))
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        NetworkLogger.shared.logTask(task, didCompleteWithError: error)
    }
}
