//
//  MockNetworkRouter.swift
//  FernHealthChallengeTests
//
//  Created by Arturo Reyes on 6/24/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

@testable import FernHealthChallenge

import Foundation
import Combine

struct MockNetworkRouter: NetworkRouter {
    
    static let mockCodes: [CodeValue:String] = [.valid: "This is a valid code",
                                                .full: "This is a full program code"]
    
    func request(_ request: URLRequest) -> AnyPublisher<Int, Error> {
        var response: URLResponse?
        
        if let requestData = request.httpBody {
            if let codeDict = JSONDataDecoder.decode(requestData) as? [String:String] {
                if let code = codeDict["code"] {
                    response = MockCodeResponse(code: code)?.urlResponse
                }
            }
        }
        
        if response == nil {
            response = MockCodeResponse.notRecognized.urlResponse
        }
        
        return AnyPublisher<Int, Error>(Just(response)
            .tryMap { response -> Int in
                guard let response = response as? HTTPURLResponse else {
                    throw HTTPError.statusCode
                }
                
                return response.statusCode
        })
    }
    
}
