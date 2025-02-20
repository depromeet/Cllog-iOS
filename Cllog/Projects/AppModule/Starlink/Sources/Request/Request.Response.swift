//
//  Requests.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation
import Combine

extension Starlink.Request {
    
    private func perform() async throws -> (Data, URLResponse) {
        
        guard let urlConversion = try? path.asURL() else {
            throw StarlinkError.inValidURLPath(ErrorInfo(code: "-999", error: nil, message: nil))
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
                throw StarlinkError.inValidURLPath(ErrorInfo(code: "-999", error: nil, message: nil))
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "\(method)"
        
            for interceptor in self.interceptors {
                urlRequest = try await interceptor.adapt(urlRequest)
            }

            urlRequest.setHeaders(headers)
            
            return try await session.data(for: urlRequest, delegate: nil)
            
        case .post, .put, .delete:
            let requestBody = try? JSONSerialization.data(withJSONObject: params ?? [:], options: [])
   
            var urlRequest = URLRequest(url: urlConversion)
            
            urlRequest.httpMethod = "\(method)"
            urlRequest.httpBody = requestBody
            
            for interceptor in self.interceptors {
                urlRequest = try await interceptor.adapt(urlRequest)
            }
            
            urlRequest.setHeaders(headers)
            
            return try await session.data(for: urlRequest, delegate: nil)
        }
    }
}

extension Starlink.Request: StarlinkRequest {
    
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
        
        do {
            self.trakers.allTrackers().forEach { $0.didRequest(self) }
            
            let (data, urlResponse) = try await self.perform()
            let response = Starlink.Response(response: urlResponse, data: data, error: nil)
            
            self.trakers.allTrackers().forEach { $0.willRequest(self, response) }
            
            let model: T = try self.validResponse(response)
            return model
            
        } catch {
            let response = Starlink.Response(response: nil, data: nil, error: error)
            self.trakers.allTrackers().forEach { $0.willRequest(self, response) }
            
            throw StarlinkError(error: error)
        }
        
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

extension StarlinkRequest {
    
    /// 유효성 체크 함수
    /// - Parameter response: 응답 response
    /// - Returns: 모델
    func validResponse<T: Decodable>(_ response: Starlink.Response) throws -> T {
        
        // 200 응답 체크
        guard let httpResponse = (response.response as? HTTPURLResponse), (200 ..< 300).contains(httpResponse.statusCode) else {
            throw StarlinkError.inValidStatusCode(errorInfo(response: response))
        }
        
        // data 언래핑
        guard let data = response.data else {
            throw StarlinkError.nullPointData(errorInfo(response: response))
        }
        
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
            
        } catch {
            throw StarlinkError.inValidJSONData(errorInfo(response: response))
        }
    }
    
    private func errorInfo(response: Starlink.Response) -> ErrorInfo {
        var message: ErrorMessage? = nil
        if let data = response.data {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []), let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted), let errorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: jsonData) {
                message = errorMessage
            }
        }
        return ErrorInfo(code: "\((response.response as? HTTPURLResponse)?.statusCode ?? -999)", error: response.error, message: message)
    }
}
