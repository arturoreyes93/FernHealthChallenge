//
//  Network.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/23/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import Foundation
import Combine

enum HTTPError: LocalizedError {
    case statusCode
}

protocol NetworkRouter {
    func request(_ request: URLRequest) -> AnyPublisher<Int, Error>
}

struct StatusCodeRouter: NetworkRouter {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request(_ request: URLRequest) -> AnyPublisher<Int, Error> {
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse else {
                    throw HTTPError.statusCode
                }
                return response.statusCode
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}
