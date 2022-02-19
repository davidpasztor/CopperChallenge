//
//  URLProtocolMock.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation

/// Mock `URLProtocol` to use in tests. Can control what `Data` and `URLResponse` or `Error` to be returned for a specific `URLRequest`.
/// Set this type as the `protocolClasses` on `URLSessionConfiguration` and use that configuration to initialise a `URLSession` using `URLSession(configuration:)` to achieve mocked requests.
class URLProtocolMock: URLProtocol {
    struct MockData {
        /// Response data for specific `URL`s
        var testResponseData = [URL: Data]()

        /// Responses for specific `URL`s
        var testResponses = [URL: URLResponse]()

        /// Errors for specific `URL`s. In case an `Error` is set for a `URL`, making a request for said `URL` will result in the `Error` being returned and the `URLResponse` and `Data` being discarded.
        var errors = [URL: Error]()
    }

    static var mockData = MockData()

    override class func canInit(with request: URLRequest) -> Bool {
        return true // Handle all requests
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request // ignore this method, just return the input
    }

    override func startLoading() {
        if let url = request.url {
            if let error = Self.mockData.errors[url] { // if we have an error, fail the request with that error, don't send a response or data
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                // If we have a test response for the specific URL, send that response
                if let response = Self.mockData.testResponses[url] {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
                }
                // If we have a test data for the specific URL, load that data
                if let data = Self.mockData.testResponseData[url] {
                    self.client?.urlProtocol(self, didLoad: data)
                }
            }
        }

        // Let the client know the request is finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Not overriding this func results in a runtime exception, however the implementation can be empty
    }

    /// Reset `mockData` to that it contains no data for any `URL`s
    static func reset() {
        mockData = MockData()
    }
}
