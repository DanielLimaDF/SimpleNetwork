//
//  Logger.swift
//  Simple Network
//
//  Created by Daniel Lima on 08/08/21.
//

import Foundation

internal final class Logger {

    internal func logSentRequest(_ request: URLRequest) {

        var message = "⬆️ "
        if let method = request.httpMethod {
            message.append(method)
        }

        if let url = request.url?.absoluteString {
            message.append(" - \(url)")
        }

        message.append("\nBody: \(extractBody(request.httpBody))")

        debugPrint(message)
    }

    internal func logRequestResponse(request: URLRequest, data: Data?, response: URLResponse?, error: Error?) {

        if let error = error {
            logError(request: request, error: error)
            return
        }

        var message = "✅ "

        if let method = request.httpMethod {
            message.append(method)
        }

        if let url = request.url?.absoluteString {
            message.append(" - \(url)")
        }

        if let httpResponse = response as? HTTPURLResponse {
            message.append(" [\(httpResponse.statusCode)]")
        }

        if let headers = (response as? HTTPURLResponse)?.allHeaderFields as? [String: Any], !headers.isEmpty {
            message.append("\n \(extractHeader(headers: headers))")
        }

        message.append("\nBody: \(extractBody(data))")

        debugPrint(message)
    }

    internal func logError(request: URLRequest, error: Error) {
        var message = "❌ "

        if let method = request.httpMethod {
            message.append(method)
        }

        if let url = request.url?.absoluteString {
            message.append(" - \(url)")
        }

        message.append("\nError: \(error.localizedDescription)")

        let nsError = error as NSError

        if let reason = nsError.localizedFailureReason {
            message.append("\nReason: \(reason)")
        }

        if let recoverySuggestion = nsError.localizedRecoverySuggestion {
            message.append("\nRecoverySuggestion: \(recoverySuggestion)")
        }

        debugPrint(message)
    }

    private func extractBody(_ data: Data?) -> String {
        guard let data = data else {
            return "nil"
        }

        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let prettyfiedData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let string = String(data: prettyfiedData, encoding: .utf8)
        {
            return string
        } else if let string = String(data: data, encoding: .utf8) {
            return string
        } else {
            return data.description
        }

    }

    private func extractHeader(headers: [String: Any]) -> String {
        var headerMessage = "Headers: [\n"

        for (key, value) in headers {
            headerMessage.append("\t\(key) : \(value)\n")
        }

        headerMessage.append("]")
        return headerMessage
    }

}
