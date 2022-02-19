//
//  URLSessionMock.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation

extension URLSession {
    /// Create a `URLSession` which returns the specified `URLResponse` and `Data` for the specified `URL`.
    static func mock(for url: URL, response: URLResponse?, data: Data?) -> URLSession {
        URLProtocolMock.mockData.testResponses[url] = response
        URLProtocolMock.mockData.testResponseData[url] = data
        return mock()
    }

    /// Create a `URLSession` which returns the specified `Error` for the specified `URL`
    static func mock(for url: URL, error: Error) -> URLSession {
        URLProtocolMock.mockData.errors[url] = error
        return mock()
    }

    /// Creates a mock `URLSession` using `URLProtocolMock`
    static func mock() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }
}
