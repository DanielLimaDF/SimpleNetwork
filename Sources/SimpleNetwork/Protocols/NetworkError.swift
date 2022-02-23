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

extension NetworkError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .parseFailed:
            return "Error on parsing data content"
        case let .defaultError(error)
            return error.localizedDescription
        case .noContent:
            return "No content"
        case .invalidURL:
            return "Invalid URL"
        }
    }

}
