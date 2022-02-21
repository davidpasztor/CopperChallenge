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

    func testNonHTTPResponse() async throws {
        // Given a URLSession which returns a non-HTTP response for a specific URL
        let url = try XCTUnwrap(URL(string: "https://testNonHTTPResponse.com"))
        let urlSession = URLSession.mock(for: url, response: URLResponse(), data: nil)
        // And a Network object initialised with this URLSession
        let network = Network(urlSession: urlSession)

        do {
            // When calling decodableRequest with the specified URL on the network instance
            _ = try await network.decodableRequest(for: url, responseModelType: String.self)
        } catch let networkingError as NetworkingError {
            // Then it throws a NetworkingError.nonHTTPResponse
            let expectedError = NetworkingError.nonHTTPResponse
            XCTAssertEqual(networkingError, expectedError)
        }
    }

    func testUnsuccessfulStatusCode() async throws {
        // Given a URLSession which returns a non success (<200 or >300) status code for a specific URL
        let url = try XCTUnwrap(URL(string: "https://testUnsuccessfulStatusCode.com"))
        let statusCode = 401
        let httpResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let urlSession = URLSession.mock(for: url, response: httpResponse, data: nil)
        // And a Network object initialised with this URLSession
        let network = Network(urlSession: urlSession)

        do {
            // When calling decodableRequest with the specified URL on the network instance
            _ = try await network.decodableRequest(for: url, responseModelType: String.self)
        } catch let networkingError as NetworkingError {
            // Then it throws a NetworkingError.unexpectedStatusCode
            let expectedError = NetworkingError.unexpectedStatusCode(statusCode)
            XCTAssertEqual(networkingError, expectedError)
        }
    }

    func testDecodingError() async throws {
        // Given a URLSession which returns an unexpected JSON for a specific URL
        let url = try XCTUnwrap(URL(string: "https://testDecodingError.com"))
        // Return an Int, while expecting a String in the JSON response
        let data = try JSONEncoder().encode(5)
        let urlSession = URLSession.mock(for: url, response: HTTPURLResponse(), data: data)
        // And a Network object initialised with this URLSession
        let network = Network(urlSession: urlSession)

        do {
            // When calling decodableRequest with the specified URL on the network instance
            _ = try await network.decodableRequest(for: url, responseModelType: String.self)
        } catch let decodingError as DecodingError {
            // Then it throws a NetworkingError.decoding
            let expectedError = DecodingError.typeMismatch(Int.self, .init(codingPath: [], debugDescription: ""))
            XCTAssertEqual(decodingError, expectedError)
        }
    }

    func testSuccess() async throws {
        let expectedValue = "success"

        // Given a URLSession which returns a success status code and the expected JSON for a specific URL
        let url = try XCTUnwrap(URL(string: "https://success.com"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = try JSONEncoder().encode("success")
        let urlSession = URLSession.mock(for: url, response: httpResponse, data: data)
        // And a Network object initialised with this URLSession
        let network = Network(urlSession: urlSession)

        // When calling decodableRequest with the specified URL on the network instance
        let valueReceived = try await network.decodableRequest(for: url, responseModelType: String.self)
        // It decodes the expected value
        XCTAssertEqual(valueReceived, expectedValue)
    }

    func testURLError() {
        // Test not finished due to time constraints, however, this would test when the dataTaskPublisher completes with a URLError
    }

    func testGenericError() {
        // Test not finished due to time constraints, however, this would test when a non-explicitly handled error is encountered in mapError
    }
}
