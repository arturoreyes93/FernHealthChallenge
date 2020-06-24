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

/// Object responsible for authenticating the code following single responsibility principle
struct CodeAuthenticatorService: CodeAuthenticator {
    
    private let url: URL = URL(string: "https://apidev.fernhealth.com/client/validateCompanyCode")!
    
    private let networkRouter: NetworkRouter
    
    var codeLength: Int { return 6 }
    
    init(networkRouter: NetworkRouter) {
        self.networkRouter = networkRouter
    }
    
    func authenticate(_ code: String) -> AnyPublisher<CodeValue?, Error> {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: ["code":code], options: .prettyPrinted)
            request.httpBody = jsonAsData
        } catch {
            print("json error: \(error.localizedDescription)")
        }
        
        return networkRouter.request(request)
            .map { CodeValue(rawValue: $0) }
            .eraseToAnyPublisher()
        
    
    }
}
