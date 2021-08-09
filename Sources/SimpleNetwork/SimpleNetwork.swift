//
//  NetworkService.swift
//  Simple Network
//
//  Created by Daniel Lima on 08/08/21.
//

import Foundation

internal typealias NetworkResponse = (_ response: HTTPURLResponse?, _ data: Data?, _ error: Error?) -> Void

public class SimpleNetwork {

    private let session: SimpleNetworkSession

    public init(networkSession: SimpleNetworkSession) {
        session = networkSession
    }

}

public extension SimpleNetwork {

    func execute(request: Requestable, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<Void, NetworkError>) -> Void) {
        session.send(request: request, completion: dispatchCallback(for: completion))
    }

    func execute<A: Decodable>(request: Requestable, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<A, NetworkError>) -> Void) {
        session.send(request: request, completion: dispatchCallback(for: completion, with: decoder))
    }

    private func dispatchCallback(for completion: @escaping (Result<Void, NetworkError>) -> Void) -> NetworkResponse {
        return { response, data, error in
            guard let error = error else {
                completion(.success(()))
                return
            }
            completion(.failure(NetworkError.defaultError(error: error)))
        }
    }

    private func dispatchCallback<A: Decodable>(for completion: @escaping (Result<A, NetworkError>) -> Void, with decoder: JSONDecoder) -> NetworkResponse {
        return { response, data, error in

            guard let data = data else {
                completion(.failure(NetworkError.noContent))
                return
            }

            guard let error = error else {
                if let result = try? decoder.decode(A.self, from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(NetworkError.parseFailed))
                }
                return
            }

            completion(.failure(NetworkError.defaultError(error: error)))
        }
    }

}
