//
//  File.swift
//  SimpleNetworkTests
//
//  Created by Daniel Lima on 23/08/21.
//

import XCTest

@testable import SimpleNetwork

final class SimpleNetworkTests: XCTestCase {
    
    var sut: SimpleNetwork!
    var urlSession: URLSessionSpy!
    
    override func setUp() {
        super.setUp()
        urlSession = URLSessionSpy()
        sut = SimpleNetwork(networkSession: SimpleNetworkSession(session: urlSession))
    }

    override func tearDown() {
        sut = nil
        urlSession = nil
        super.tearDown()
    }
    
    func testVoidResult() {
        var isFailure: Bool = false
        var networkError: Error?
        let expectation = XCTestExpectation(description: "Test request expectation")
        var result: Result<Void, NetworkError>?
        sut.execute(request: RouterDummy()) {
            result = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        switch result {
        case .success:
            isFailure = false
        case let .failure(error):
            networkError = error
            isFailure = true
        case .none:
            XCTFail("No result returned")
        }
        
        XCTAssertNil(networkError)
        XCTAssertFalse(isFailure)
    }
    
    func testVoidResultWhithError() {
        var isFailure: Bool = false
        var networkError: Error?
        let expectation = XCTestExpectation(description: "Test request expectation")
        urlSession.forceError = true
        var result: Result<Void, NetworkError>?
        sut.execute(request: RouterDummy()) {
            result = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        switch result {
        case .success:
            isFailure = false
        case let .failure(error):
            networkError = error
            isFailure = true
        case .none:
            XCTFail("No result returned")
        }
        
        XCTAssertNotNil(networkError)
        XCTAssertTrue(isFailure)
    }
    
    func testDecodedValueResult() {
        var isFailure: Bool = false
        var networkError: Error?
        var resultValue: [DecodableDummy]?
        let expectation = XCTestExpectation(description: "Test request expectation")
        
        let completion: (Result<[DecodableDummy], NetworkError>) -> Void = { result in
            switch result {
            case let .success(value):
                resultValue = value
                isFailure = false
                expectation.fulfill()
            case let .failure(error):
                networkError = error
                isFailure = true
                expectation.fulfill()
            }
        }
        
        sut.execute(request: RouterDummy(), completion: completion)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNotNil(resultValue)
        XCTAssertEqual(resultValue?.count, 1)
        XCTAssertNil(networkError)
        XCTAssertFalse(isFailure)
    }
    
    func testDecodedValueResultWhithError() {
        var isFailure: Bool = false
        var networkError: Error?
        var resultValue: [DecodableDummy]?
        let expectation = XCTestExpectation(description: "Test request expectation")
        urlSession.forceError = true
        
        let completion: (Result<[DecodableDummy], NetworkError>) -> Void = { result in
            switch result {
            case let .success(value):
                resultValue = value
                isFailure = false
                expectation.fulfill()
            case let .failure(error):
                networkError = error
                isFailure = true
                expectation.fulfill()
            }
        }
        
        sut.execute(request: RouterDummy(), completion: completion)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(resultValue)
        XCTAssertNotNil(networkError)
        XCTAssertTrue(isFailure)
    }
    
    func testDecodedValueResultWhithParseError() {
        var isFailure: Bool = false
        var networkError: Error?
        var resultValue: [DecodableDummy]?
        let expectation = XCTestExpectation(description: "Test request expectation")
        urlSession.dataString = "{dummy: 1}"
        
        let completion: (Result<[DecodableDummy], NetworkError>) -> Void = { result in
            switch result {
            case let .success(value):
                resultValue = value
                isFailure = false
                expectation.fulfill()
            case let .failure(error):
                networkError = error
                isFailure = true
                expectation.fulfill()
            }
        }
        
        sut.execute(request: RouterDummy(), completion: completion)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(resultValue)
        XCTAssertNotNil(networkError)
        XCTAssertTrue(isFailure)
    }
    
    func testDecodedValueResultWhithServerError() {
        var isFailure: Bool = false
        var networkError: Error?
        var resultValue: [DecodableDummy]?
        let expectation = XCTestExpectation(description: "Test request expectation")
        urlSession.dataString = String()
        urlSession.resutlError = NSError(domain: "fakeDomain", code: 503, userInfo: nil)
        
        let completion: (Result<[DecodableDummy], NetworkError>) -> Void = { result in
            switch result {
            case let .success(value):
                resultValue = value
                isFailure = false
                expectation.fulfill()
            case let .failure(error):
                networkError = error
                isFailure = true
                expectation.fulfill()
            }
        }
        
        sut.execute(request: RouterDummy(), completion: completion)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(resultValue)
        XCTAssertNotNil(networkError)
        XCTAssertTrue(isFailure)
    }
    
}
