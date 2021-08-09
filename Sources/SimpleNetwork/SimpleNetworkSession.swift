//
//  SimpleNetworkSession.swift
//  Simple Network
//
//  Created by Daniel Lima on 08/08/21.
//

import Foundation

public class SimpleNetworkSession {

    private let urlSession: URLSession
    private let logger: Logger

    init() {
        urlSession = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue()
        )
        logger = Logger()
    }

    internal func send(request: Requestable, completion: @escaping NetworkResponse) {

        do {
            let urlRequest = try request.urlRequest()

            let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
                self?.logger.logRequestResponse(request: urlRequest, data: data, response: response, error: error)

                DispatchQueue.main.async {
                    let httpResponse = response as? HTTPURLResponse
                    completion(httpResponse, data, error)
                }

            }

            logger.logSentRequest(urlRequest)
            task.resume()
        } catch {
            DispatchQueue.main.async {
                completion(nil, nil, error)
            }
        }

    }

}
