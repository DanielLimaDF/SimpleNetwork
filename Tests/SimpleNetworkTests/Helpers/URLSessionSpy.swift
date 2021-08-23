//
//  URLSessionSpy.swift
//  SimpleNetworkTests
//
//  Created by Daniel Lima on 23/08/21.
//

import Foundation

@testable import SimpleNetwork

final class URLSessionDataTaskFake: URLSessionDataTask {
    override func resume() {}
}

final class URLSessionSpy: URLSession {
    
    var wasDataTaskCalled = false
    var forceError = false
    var dataString = "[{}]"
    var resutlError: Error? = nil
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        wasDataTaskCalled = true
        
        if forceError {
            completionHandler(nil, nil, NSError(domain: "fakeDomain", code: 0, userInfo: nil))
        } else {
            completionHandler(
                dataString.data(using: .utf8),
                HTTPURLResponse(url: URL(string: "http://faleURL")!, statusCode: 200, httpVersion: nil, headerFields: nil),
                resutlError
            )
        }
        
        return URLSessionDataTaskFake()
    }
    
}
