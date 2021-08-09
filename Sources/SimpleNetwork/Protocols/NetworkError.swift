//
//  NetworkError.swift
//  Simple Network
//
//  Created by Daniel Lima on 08/08/21.
//

import Foundation

public enum NetworkError: Error {
    case parseFailed
    case defaultError(error: Error)
    case noContent
    case invalidURL
}
