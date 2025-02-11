//
//  SpaceX.Request.Perform.swift
//  SpaceXTests
//
//  Created by saeng lin on 1/27/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import Combine

extension SpaceX.Request {
    
    private func perform() async throws -> (Data, URLResponse) {
        
        guard let urlConversion = try? path.asURL() else {
            throw NSError(domain: "inValidURLPath", code: -999)
        }
        
        var urlComponents = URLComponents(string: urlConversion.absoluteString)
        
        switch method {
        case .get:
            
            var parameters: [URLQueryItem] = urlComponents?.queryItems ?? []
            
            params?.forEach({ key, value in
                parameters.append(URLQueryItem(name: key, value: "\(value)"))
            })
            
            urlComponents?.queryItems = parameters
            
            guard let url = urlComponents?.url else {
                throw NSError(domain: "inValidURLPath", code: -999)
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "\(method)"
            
            return try await session.data(for: urlRequest)
            
        case .post, .put, .delete:
            let requestBody = try? JSONSerialization.data(withJSONObject: params ?? [:], options: [])
   
            var urlRequest = URLRequest(url: urlConversion)
            
            urlRequest.httpMethod = "\(method)"
            urlRequest.httpBody = requestBody
            
            return try await session.data(for: urlRequest)
        }
    }
}

extension SpaceX.Request: SpaceXRequest {
    
    public func reponsePublisher<T: Decodable>() -> AnyPublisher<T, any Error> {
        return Future<T, Error> { @Sendable promise in
            Task {
                do {
                    let model: T = try await reponseAsync()
                    promise(.success(model))
                    
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func reponseAsync<T: Decodable>() async throws -> T {
        
        self.trakers.forEach { $0.didRequest(self) }
        
        let (data, urlResponse) = try await self.perform()
        let spaceXResponse = SpaceX.Response(response: urlResponse, data: data, error: nil)
        
        self.trakers.forEach { $0.willRequest(self, spaceXResponse) }
        
        let model: T = try self.validResponse(spaceXResponse)
        return model
    }
    
    public func response<T: Decodable>(_ complete: @escaping @Sendable (Result<T, any Error>) -> Void) {
        Task {
            do {
                let model: T = try await reponseAsync()
                complete(.success(model))
            } catch {
                complete(.failure(error))
            }
        }
    }
}

extension SpaceXRequest {
    
    /// 유효성 체크 함수
    /// - Parameter response: 응답 response
    /// - Returns: 모델
    func validResponse<T: Decodable>(_ response: SpaceX.Response) throws -> T {
        
        // 200 응답 체크
        guard let httpResponse = (response.response as? HTTPURLResponse), (200 ..< 300).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Invalid Status", code: -999)
        }
        
        // data 언래핑
        guard let data = response.data else {
            throw NSError(domain: "nullPointData", code: -999)
        }
        
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
            
        } catch {
            throw NSError(domain: "inValidJSONData", code: -999)
        }
    }
}
