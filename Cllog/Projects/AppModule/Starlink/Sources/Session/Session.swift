//
//  Session.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

public protocol Sessionable: Sendable {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: Sessionable {}
