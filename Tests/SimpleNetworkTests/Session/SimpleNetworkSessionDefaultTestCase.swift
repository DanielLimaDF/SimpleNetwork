//
//  SimpleNetworkSessionDefaultTestCase.swift
//  SimpleNetworkTests
//
//  Created by Daniel Lima on 23/08/21.
//

import XCTest

@testable import SimpleNetwork

final class SimpleNetworkSessionDefaultTestCase: XCTestCase {
    
    var sut: SimpleNetworkSession!
    
    override func setUp() {
        super.setUp()
        sut = SimpleNetworkSession()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testDefaultConfiguration() {
        XCTAssertEqual(sut.urlSession.configuration, URLSessionConfiguration.default)
    }
    
}
