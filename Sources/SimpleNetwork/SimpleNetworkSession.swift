//
//  SimpleNetworkSession.swift
//  Simple Network
//
//  Created by Daniel Lima on 08/08/21.
//

import Foundation

public class SimpleNetworkSession {

    internal let urlSession: URLSession
    internal let logger: Logger
    internal let basicCredentials: String

    public init(session: URLSession? = nil, basicAuthorization: String) {
        basicCredentials = basicAuthorization
        urlSession = session ?? URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue()
        )
        logger = Logger()
    }

    internal func send(request: Requestable, completion: @escaping NetworkResponse) {

        do {
            var urlRequest = try request.urlRequest()
            urlRequest.setValue(basicCredentials, forHTTPHeaderField: "Authorization")

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
