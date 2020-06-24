//
//  FernHealthChallengeTests.swift
//  FernHealthChallengeTests
//
//  Created by Arturo Reyes on 6/24/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

@testable import FernHealthChallenge
import XCTest
import Combine


class CodeAuthenticatorTests: XCTestCase {
    
    let testTimeout: TimeInterval = 1
    
    var authenticator: CodeAuthenticatorService!

    override func setUp() {
        authenticator = CodeAuthenticatorService(networkRouter: MockNetworkRouter())
    }

    override func tearDown() {
        authenticator = nil
    }

    func testValidCode() {
        let validCode = MockCodeResponse.valid.rawValue
        let validFuture = authenticator.authenticate(validCode)
        let validTest = evalValidCodeTest(publisher: validFuture)
        wait(for: validTest.expectations, timeout: testTimeout)
        XCTAssertEqual(validTest.result, CodeValue.valid)
        validTest.cancellable?.cancel()
    }
    
    func testFullCode() {
        let fullCode = MockCodeResponse.full.rawValue
        let fullFuture = authenticator.authenticate(fullCode)
        let fullTest = evalValidCodeTest(publisher: fullFuture)
        wait(for: fullTest.expectations, timeout: testTimeout)
        XCTAssertEqual(fullTest.result, CodeValue.full)
        fullTest.cancellable?.cancel()
    }
    
    func testNotRecognizedCode() {
        let notRecognizedCode = "Any other string is not recognized"
        let notRecognizedFuture = authenticator.authenticate(notRecognizedCode)
        let notRecognizedTest = evalValidCodeTest(publisher: notRecognizedFuture)
        wait(for: notRecognizedTest.expectations, timeout: testTimeout)
        XCTAssertEqual(notRecognizedTest.result, CodeValue.notRecognized)
        notRecognizedTest.cancellable?.cancel()
    }
    
    func evalValidCodeTest(publisher: AnyPublisher<CodeValue?, Error>?) -> (result: CodeValue?, expectations:[XCTestExpectation], cancellable: AnyCancellable?) {
        XCTAssertNotNil(publisher)
        
        let expectationFinished = expectation(description: "finished")
        let expectationReceive = expectation(description: "receiveValue")
        let expectationFailure = expectation(description: "failure")
        expectationFailure.isInverted = true
        
        var result: CodeValue?
        
        let cancellable = publisher?.sink (receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
                expectationFailure.fulfill()
            case .finished:
                expectationFinished.fulfill()
            }
        }, receiveValue: { response in
            XCTAssertNotNil(response)
            result = response
            expectationReceive.fulfill()
        })
        return (result, expectations: [expectationFinished, expectationReceive, expectationFailure],
                cancellable: cancellable)
    }
    
}

