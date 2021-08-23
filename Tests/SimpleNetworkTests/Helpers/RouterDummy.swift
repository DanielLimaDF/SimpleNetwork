//
//  RouterDummy.swift
//  SimpleNetworkTests
//
//  Created by Daniel Lima on 23/08/21.
//

import Foundation

@testable import SimpleNetwork

struct RouterDummy: Requestable {
    var method: HTTPMethod
    var path: String
    var parameters: Parameters?
    var throwError: Bool
    
    init() {
        method = .get
        path = "https://fakePath"
        throwError = false
    }
    
    func urlRequest() throws -> URLRequest {
        if !throwError {
            return URLRequest(url: URL(string: path) ?? URL(fileURLWithPath: "fakePath"))
        } else {
            throw NSError(domain: String(), code: 0, userInfo: nil)
        }
    }
}
