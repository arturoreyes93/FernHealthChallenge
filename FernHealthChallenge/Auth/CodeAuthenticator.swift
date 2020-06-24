//
//  CodeValidator.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/20/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import Foundation
import Combine

/// Abstract Code Authenticator Object into a Protocol
protocol CodeAuthenticator {
    // Helps to ensure that the code is validated only if its length is the same as this value
    var codeLength: Int { get }
    
    func authenticate(_ code: String) -> AnyPublisher<CodeValue?, Error>
}

/// Responsible for authenticating the code following single responsibility principles for optimum testing
public struct CodeAuthenticatorService: CodeAuthenticator {
    
    static let url: URL = URL(string: "https://apidev.fernhealth.com/client/validateCompanyCode")!
    
    private let networkRouter: NetworkRouter
    
    var codeLength: Int { return 6 }
    
    init(networkRouter: NetworkRouter = StatusCodeRouter()) {
        self.networkRouter = networkRouter
    }
    
    func authenticate(_ code: String) -> AnyPublisher<CodeValue?, Error> {
        
        var request = URLRequest(url: CodeAuthenticatorService.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: ["code":code], options: .prettyPrinted)
            request.httpBody = jsonAsData
        } catch {
            print("json error: \(error.localizedDescription)")
            return AnyPublisher<CodeValue?, Error>(Fail(error: error))
        }
        
        return networkRouter.request(request)
            .map { CodeValue(rawValue: $0) }
            .eraseToAnyPublisher()
        
    
    }
}
