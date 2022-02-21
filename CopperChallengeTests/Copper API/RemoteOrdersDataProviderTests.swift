//
//  RemoteOrdersDataProviderTests.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

import XCTest
import Combine
@testable import CopperChallenge

final class RemoteOrdersDataProviderTests: CombineXCTestCase {
    func testFetchOrdersSuccess() async throws {
        // Given an OrdersResponseModel JSON
        let responseData = try JSONLoader.loadJSONData(fileName: "Orders")
        // A NetworkMock initialised to return an OrdersResponseModel decoded from this JSON
        let network = NetworkMock(requestResults: .success(responseData))
        // and a RemoteOrdersDataProvider initialised with this NetworkMock
        let dataProvider = RemoteOrdersDataProvider(network: network, cachedOrdersDataProvider: CachedOrdersDataProvider.preview)

        // When calling fetchOrders on the data provider
        try await dataProvider.fetchOrders()
        // Then the method succeeds without throwing any errors
    }

    func testFetchOrdersFailure() async throws {
        // Given a NetworkingError
        let networkingError = NetworkingError.nonHTTPResponse
        // A NetworkMock initialised to return this error
        let network = NetworkMock(requestResults: .failure(networkingError))
        // and a RemoteOrdersDataProvider initialised with this NetworkMock
        let dataProvider = RemoteOrdersDataProvider(network: network, cachedOrdersDataProvider: CachedOrdersDataProvider.preview)

        do {
            // When calling fetchOrders on the data provider
            _ = try await dataProvider.fetchOrders()
        } catch let ordersError as OrdersError {
            XCTAssertEqual(ordersError, .networking(networkingError))
        }
    }
}
