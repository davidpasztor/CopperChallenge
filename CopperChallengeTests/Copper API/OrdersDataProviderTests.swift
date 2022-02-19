//
//  OrdersDataProviderTests.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

import XCTest
import Combine
@testable import CopperChallenge

final class OrdersDataProviderTests: CombineXCTestCase {
    func testOrdersPublisherSuccess() throws {
        // Given an OrdersResponseModel JSON
        let responseData = try JSONLoader.loadJSONData(fileName: "Orders")
        // A NetworkMock initialised to return an OrdersResponseModel decoded from this JSON
        let network = NetworkMock(requestResults: .success(responseData))
        // and an OrdersDataProvider initialised with this NetworkMock
        let dataProvider = OrdersDataProvider(network: network)

        var completionReceived: Subscribers.Completion<OrdersError>?
        var valueReceived: [OrderResponseModel]?

        let expectation = XCTestExpectation(description: "ordersPublisher should have completed")

        // When calling ordersPublisher on the data provider and subscribing to this publisher
        dataProvider.ordersPublisher()
            .sink(receiveCompletion: { completion in
                completionReceived = completion
                expectation.fulfill()
            }, receiveValue: { value in
                valueReceived = value
            }).store(in: &subscriptions)

        wait(for: [expectation], timeout: 1.0)
        // Then the publisher emits the expected decoded model object and completes with success
        let rootResponse = try JSONDecoder().decode(OrdersResponseModel.self, from: responseData)
        let expectedStations = rootResponse.orders
        XCTAssertEqual(valueReceived, expectedStations)
        XCTAssertEqual(completionReceived, .finished)
    }

    func testOrdersPublisherFailure() {
        // Given a NetworkingError
        let networkingError = NetworkingError.nonHTTPResponse
        // A NetworkMock initialised to return this error
        let network = NetworkMock(requestResults: .failure(networkingError))
        // and an OrdersDataProvider initialised with this NetworkMock
        let dataProvider = OrdersDataProvider(network: network)

        var completionReceived: Subscribers.Completion<OrdersError>?
        var valueReceived: [OrderResponseModel]?

        let expectation = XCTestExpectation(description: "ordersPublisher should have completed")

        // When calling ordersPublisher on the data provider and subscribing to this publisher
        dataProvider.ordersPublisher()
            .sink(receiveCompletion: { completion in
                completionReceived = completion
                expectation.fulfill()
            }, receiveValue: { value in
                valueReceived = value
            }).store(in: &subscriptions)

        wait(for: [expectation], timeout: 1.0)
        // Then the publisher emits no value and completes with the expected error
        XCTAssertNil(valueReceived)
        XCTAssertEqual(completionReceived, .failure(.networking(networkingError)))
    }
}
