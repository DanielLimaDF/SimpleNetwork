//
//  NetworkErrorTestCase.swift
//  SimpleNetworkTests
//
//  Created by Daniel Lima on 22/02/22.
//

import Foundation
import XCTest

@testable import SimpleNetwork

class NetworkErrorTestCase: XCTestCase {

    var sut: NetworkError!

    override func setUp() {
        super.setUp()
        sut = NetworkError.parseFailed
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testParseFailedDescription() {
        XCTAssertEqual(sut.localizedDescription, "Error on parsing data content")
    }

    func testNoContentDescription() {
        sut = NetworkError.noContent
        XCTAssertEqual(sut.localizedDescription, "No content")
    }

    func testInvalidURLDescription() {
        sut = NetworkError.invalidURL
        XCTAssertEqual(sut.localizedDescription, "Invalid URL")
    }

    func testDefaultErrorDescription() {
        sut = NetworkError.defaultError(error: NSError(domain: "fake.domain.com", code: 404, userInfo: [NSLocalizedDescriptionKey : "fake error message"]))
        XCTAssertEqual(sut.localizedDescription, "fake error message")
    }

}
