//
//  OrdersDataProviderMock.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 21/02/2022.
//

@testable import CopperChallenge

final class OrdersDataProviderMock: OrdersDataProvider {
    /// The value to be returned by the `hasCachedOrders` method
    var hasCachedOrdersValue: Bool
    /// The result to use in the `fetchOrders` method.
    /// If `success`, the `fetchOrders` method returns without throwing an error
    /// If `failure`, the `fetchOrders` method throws the contained error
    var fetchOrdersResult: Result<Void, Error>

    /// Whether the `fetchOrders` method has been called
    var fetchOrdersCalled: Bool = false

    init(hasCachedOrders: Bool = false, fetchOrdersResult: Result<Void, Error> = .success(Void())) {
        self.hasCachedOrdersValue = hasCachedOrders
        self.fetchOrdersResult = fetchOrdersResult
    }

    func fetchOrders() async throws {
        fetchOrdersCalled = true
        switch fetchOrdersResult {
        case .success:
            hasCachedOrdersValue = true
            return
        case let .failure(error):
            throw error
        }
    }

    func hasCachedOrders() throws -> Bool {
        hasCachedOrdersValue
    }
}
