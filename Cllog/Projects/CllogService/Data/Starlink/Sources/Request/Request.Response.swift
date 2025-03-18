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
        
        let urlComponents = URLComponents(string: urlConversion.absoluteString)
        
        var urlRequest = URLRequest(url: urlConversion)
        urlRequest.httpMethod = "\(method)"
        
        if let parameters = params?.toDictionary() {
            try urlRequest = encoding.encode(&urlRequest, with: parameters)
        }
        
        for interceptor in self.interceptors {
            urlRequest = try await interceptor.adapt(&urlRequest)
        }
        
        urlRequest.setHeaders(headers)
        
        self.trakers.allTrackers().forEach { $0.didRequest(self, urlRequest: urlRequest) }
        
        do {
            let (data, response) = try await session.data(for: urlRequest, delegate: nil)
            return (data, response)
        } catch {
            
            let response = Starlink.Response(response: nil, data: nil, error: error)
            self.trakers.allTrackers().forEach { $0.willRequest(self, response) }
            
            // retry Count가 최대 retry 갯수보다 낮으면 retry
            guard self.retryCount < self.retryLimit else {
                throw error
            }
            
            // default는 다시 요청 하지 않음
            var retryResult: StartlinkRetryType = .doNotRetry
            
            self.retryCount += 1
            
            for interceptor in self.interceptors {
                let (retryURLRequest, retryType)  = try await interceptor.retry(&urlRequest, response: response)
                urlRequest = retryURLRequest
                retryResult = retryType
            }
            
            switch retryResult {
            case .retry:
                // 재요청 이면 요청
                return try await perform()
                
            case .doNotRetry:
                // retry를 하지 않으면 throw error
                throw error
            }
        }
    }
}

extension Starlink.Request: StarlinkRequest {
    
    public func reponsePublisher<T: Decodable>() -> AnyPublisher<T, any Error> {
        return Future<T, Error> { @Sendable [weak self] promise in
            guard let self else { return }
            Task {
                do {
                    let model: T = try await self.reponseAsync()
                    promise(.success(model))
                    
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func reponseAsync<T: Decodable>() async throws -> T {
        do {
            let (data, urlResponse) = try await self.perform()
            let response = Starlink.Response(response: urlResponse, data: data, error: nil)
            self.trakers.allTrackers().forEach { $0.willRequest(self, response) }
            let model: T = try self.validResponse(response)
            return model
        } catch {
            throw StarlinkError(error: error)
        }
        
    }
    
    public func response<T: Decodable>(_ complete: @escaping @Sendable (Result<T, any Error>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let model: T = try await reponseAsync()
                complete(.success(model))
            } catch {
                complete(.failure(error))
            }
        }
    }
    
    public func upload<T: Decodable>() async throws -> T {
        guard let uploadForm = self.uploadForm else {
            throw StarlinkError.inValidParams(.init(code: "-999", error: nil, message: .init(message: "Upload form is missing")))
        }
        
        guard let urlConversion = try? path.asURL() else {
            throw StarlinkError.inValidURLPath(ErrorInfo(code: "-999", error: nil, message: nil))
        }
        
        var urlRequest = URLRequest(url: urlConversion)
        urlRequest.httpMethod = "\(method)"
        
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        
        if let parameters = params?.toDictionary() {
            for (key, value) in parameters {
                httpBody.appendFormat("--\(boundary)\r\n".data(using: .utf8))
                httpBody.appendFormat("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8))
                httpBody.appendFormat("\(value)\r\n".data(using: .utf8))
            }
        }
        
        httpBody.appendFormat("--\(boundary)\r\n".data(using: .utf8))
        httpBody.appendFormat("Content-Disposition: form-data; name=\"\(uploadForm.name)\"; filename=\"\(uploadForm.fileName)\"\r\n".data(using: .utf8))
        httpBody.appendFormat("Content-Type: \(uploadForm.mimeType)\r\n\r\n".data(using: .utf8))
        httpBody.append(uploadForm.data)
        httpBody.appendFormat("\r\n".data(using: .utf8))
        httpBody.appendFormat("--\(boundary)--".data(using: .utf8))
        
        urlRequest.httpBody = httpBody as Data
        
        for interceptor in self.interceptors {
            urlRequest = try await interceptor.adapt(&urlRequest)
        }
        
        urlRequest.setHeaders(headers)
        
        self.trakers.allTrackers().forEach { $0.didRequest(self, urlRequest: urlRequest) }

        do {
            let (data, urlResponse) = try await session.data(for: urlRequest, delegate: nil)
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

extension Data {
    mutating func appendFormat(_ data: Data?) {
        if let data {
            self.append(data)
        }
    }
}
