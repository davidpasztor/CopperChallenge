//
//  NetworkingError.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation

enum NetworkingError: LocalizedError {
    case decoding(DecodingError)
    case generic(Error)
    case nonHTTPResponse
    case unexpectedStatusCode(Int)
    case url(URLError)

    var failureReason: String? {
        let tryAgainLater = "Please try again later"

        switch self {
        case let .decoding(decodingError):
            return "We ran into an issue. \(decodingError.localizedDescription)\n \(tryAgainLater)"
        case let .generic(error):
            return "We ran into an unexpected issue. \(error.localizedDescription)\n \(tryAgainLater)"
        case .nonHTTPResponse:
            return "We ran into a networking issue. \(tryAgainLater)"
        case let .unexpectedStatusCode(statusCode):
            return "We ran into a networking issue. Unexpected status code \(statusCode).\n \(tryAgainLater)."
        case let .url(urlError):
            return "We ran into a networking issue. \(urlError.localizedDescription)\n \(tryAgainLater)"
        }
    }
}
