//
//  StatusCodeResponse.swift
//  FernHealthChallengeTests
//
//  Created by Arturo Reyes on 6/24/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

@testable import FernHealthChallenge
import Foundation


enum MockCodeResponse: String {
    case valid
    case full
    case notRecognized
    
    init?(code: String) {
        switch code {
        case MockCodeResponse.valid.rawValue: self = MockCodeResponse.valid
        case MockCodeResponse.full.rawValue : self = MockCodeResponse.full
        default : self = MockCodeResponse.notRecognized
        }
    }
    
    var statusCode: Int {
        switch self {
        case .valid        : return CodeValue.valid.rawValue
        case .full         : return CodeValue.full.rawValue
        case .notRecognized: return CodeValue.notRecognized.rawValue
        }
    }
    
    var urlResponse: URLResponse? {
        switch self {
        case .valid        : return HTTPURLResponse(url: CodeAuthenticatorService.url,
                                                    statusCode: CodeValue.valid.rawValue,
                                                    httpVersion: nil,
                                                    headerFields: nil)
        case .full         : return HTTPURLResponse(url: CodeAuthenticatorService.url,
                                                    statusCode: CodeValue.full.rawValue,
                                                    httpVersion: nil,
                                                    headerFields: nil)
        default: return HTTPURLResponse(url: CodeAuthenticatorService.url,
                                                    statusCode: CodeValue.notRecognized.rawValue,
                                                    httpVersion: nil,
                                                    headerFields: nil)
            
        }
    }
}
