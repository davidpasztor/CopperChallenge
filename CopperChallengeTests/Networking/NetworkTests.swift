//
//  NetworkTests.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

import XCTest
import Combine
@testable import CopperChallenge

final class NetworkTests: CombineXCTestCase {

    override func tearDown() {
        super.tearDown()

        URLProtocolMock.reset()
    }

    func testNonHTTPResponse() throws {
        var valueReceived: String?
        var completionReceived: Subscribers.Completion<NetworkingError>?

        let completionExpectation = expectation(description: "Network.decodableRequestPublisher should have completed")

        // Given a URLSession which returns a non-HTTP response for a specific URL
        let url = try XCTUnwrap(URL(string: "https://testNonHTTPResponse.com"))
        let urlSession = URLSession.mock(for: url, response: URLResponse(), data: nil)
        // And a Network object initialised with this URLSession
        let network = Network(urlSession: urlSession)

        // When creating a subscription to decodableRequestPublisher called with the specified URL on the Network instance
        network.decodableRequestPublisher(for: url, responseModelType: String.self).sink(receiveCompletion: { completion in
            completionReceived = completion
            completionExpectation.fulfill()
        }, receiveValue: {
            valueReceived = $0
        }).store(in: &subscriptions)

        // Then the publisher fails with the expected error without emitting any values
        let expectedError = NetworkingError.nonHTTPResponse
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(valueReceived)
        XCTAssertEqual(completionReceived, .failure(expectedError))
    }

    func testUnsuccessfulStatusCode() throws {
        var valueReceived: String?
        var completionReceived: Subscribers.Completion<NetworkingError>?

        let completionExpectation = expectation(description: "Network.decodableRequestPublisher should have completed")

        // Given a URLSession which returns a non success (<200 or >300) status code for a specific URL
        let url = try XCTUnwrap(URL(string: "https://testUnsuccessfulStatusCode.com"))
        let statusCode = 401
        let httpResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let urlSession = URLSession.mock(for: url, response: httpResponse, data: nil)
        // And a Network object initialised with this URLSession
        let network = Network(urlSession: urlSession)

        // When creating a subscription to decodableRequestPublisher called with the specified URL on the Network instance
        network.decodableRequestPublisher(for: url, responseModelType: String.self).sink(receiveCompletion: { completion in
            completionReceived = completion
            completionExpectation.fulfill()
        }, receiveValue: {
            valueReceived = $0
        }).store(in: &subscriptions)

        // Then the publisher fails with the expected error without emitting any values
        let expectedError = NetworkingError.unexpectedStatusCode(statusCode)
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(valueReceived)
        XCTAssertEqual(completionReceived, .failure(expectedError))
    }

    func testDecodingError() throws {
        var valueReceived: String?
        var completionReceived: Subscribers.Completion<NetworkingError>?

        let completionExpectation = expectation(description: "Network.decodableRequestPublisher should have completed")

        // Given a URLSession which returns an unexpected JSON for a specific URL
        let url = try XCTUnwrap(URL(string: "https://testDecodingError.com"))
        // Return an Int, while expecting a String in the JSON response
        let data = try JSONEncoder().encode(5)
        let urlSession = URLSession.mock(for: url, response: HTTPURLResponse(), data: data)
        // And a Network object initialised with this URLSession
        let network = Network(urlSession: urlSession)

        // When creating a subscription to decodableRequestPublisher called with the specified URL on the Network instance
        network.decodableRequestPublisher(for: url, responseModelType: String.self).sink(receiveCompletion: { completion in
            completionReceived = completion
            completionExpectation.fulfill()
        }, receiveValue: {
            valueReceived = $0
        }).store(in: &subscriptions)

        // Then the publisher fails with the expected error without emitting any values
        let expectedError = NetworkingError.decoding(.typeMismatch(Int.self, .init(codingPath: [], debugDescription: "")))
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(valueReceived)
        XCTAssertEqual(completionReceived, .failure(expectedError))
    }

    func testSuccess() throws {
        var valueReceived: String?
        var completionReceived: Subscribers.Completion<NetworkingError>?

        let completionExpectation = expectation(description: "Network.decodableRequestPublisher should have completed")
        let expectedValue = "success"

        // Given a URLSession which returns a success status code and the expected JSON for a specific URL
        let url = try XCTUnwrap(URL(string: "https://success.com"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = try JSONEncoder().encode("success")
        let urlSession = URLSession.mock(for: url, response: httpResponse, data: data)
        // And a Network object initialised with this URLSession
        let network = Network(urlSession: urlSession)

        // When creating a subscription to decodableRequestPublisher called with the specified URL on the Network instance
        network.decodableRequestPublisher(for: url, responseModelType: String.self).sink(receiveCompletion: { completion in
            completionReceived = completion
            completionExpectation.fulfill()
        }, receiveValue: {
            valueReceived = $0
        }).store(in: &subscriptions)

        // Then the publisher succeeds after emitting the expected value
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(valueReceived, expectedValue)
        XCTAssertEqual(completionReceived, .finished)
    }

    func testURLError() {
        // Test not finished due to time constraints, however, this would test when the dataTaskPublisher completes with a URLError
    }

    func testGenericError() {
        // Test not finished due to time constraints, however, this would test when a non-explicitly handled error is encountered in mapError
    }
}
