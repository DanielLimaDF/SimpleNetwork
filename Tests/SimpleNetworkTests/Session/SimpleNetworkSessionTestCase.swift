//
//  SimpleNetworkSessionTestCase.swift
//  SimpleNetworkTests
//
//  Created by Daniel Lima on 23/08/21.
//

import XCTest

@testable import SimpleNetwork

final class SimpleNetworkSessionTestCase: XCTestCase {
    
    var sut: SimpleNetworkSession!
    var session: URLSessionSpy!
    
    override func setUp() {
        super.setUp()
        session = URLSessionSpy()
        sut = SimpleNetworkSession(session: session)
    }

    override func tearDown() {
        sut = nil
        session = nil
        super.tearDown()
    }
    
    func testSend() {
        let expectation = XCTestExpectation(description: "Test request expectation")
        var resultError: Error?
        sut.send(request: RouterDummy()) { _, _, error in
            resultError = error
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(session.wasDataTaskCalled)
        XCTAssertNil(resultError)
    }
    
    func testSendWithError() {
        session.forceError = true
        let expectation = XCTestExpectation(description: "Test request expectation")
        var resultError: Error?
        sut.send(request: RouterDummy()) { _, _, error in
            resultError = error
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(session.wasDataTaskCalled)
        XCTAssertNotNil(resultError)
    }
    
    func testSendWithInternalError() {
        let expectation = XCTestExpectation(description: "Test request expectation")
        var resultError: Error?
        var dummy = RouterDummy()
        dummy.throwError = true
        sut.send(request: dummy) { _, _, error in
            resultError = error
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(session.wasDataTaskCalled)
        XCTAssertNotNil(resultError)
    }
    
}
