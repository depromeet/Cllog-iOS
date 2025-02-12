//
//  Sample.swift
//  Sample
//
//  Created by Junyoung on 1/8/25.
//

import Foundation
import Combine

import SpaceX

struct EmptyModel: Decodable {
    
}

class AA {
    
    private var cancellable = Set<AnyCancellable>()
    
    func request() {
        
        let request = SpaceX.session.request("", method: .get)
        
        Task {
            do {
                // 사용법
                let model: EmptyModel = try await request.reponseAsync()
                
            } catch {
                
            }
        }
        
        
        AA.requestPublisher()
            .sink { completion in
                
            } receiveValue: { model in
                
            }.store(in: &cancellable)

        request.response { (result: Result<EmptyModel, any Error>) in
            switch result {
            case .success(let model):
                print()
                
            case .failure(let error):
                print()
            }
        }
    }
    
    static func requestPublisher() -> AnyPublisher<EmptyModel, any Error> {
        return SpaceX.session.request("", method: .get).reponsePublisher()
    }
}
