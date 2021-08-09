//
//  Requestable.swift
//  Simple Network
//
//  Created by Daniel Lima on 08/08/21.
//

import Foundation

public typealias Parameters = [String: Any]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol Requestable {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    func urlRequest() throws -> URLRequest
}
