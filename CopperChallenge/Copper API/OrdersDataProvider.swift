//
//  OrdersDataProvider.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Combine
import Foundation
import CoreData
import OSLog

protocol OrdersDataProvider {
    /// Fetch and cache orders if they are not already cached in `cachedOrdersDataProvider`
    func fetchOrders() async throws
    /// Whether there are cached orders in the storage
    func hasCachedOrders() throws -> Bool
    /// Persistent storage for the fetched orders
    var cachedOrdersDataProvider: OrdersPersistentStorage { get }
}

/// A data provider that fetches orders from a remote API, then caches them in a persistent store
final class RemoteOrdersDataProvider: OrdersDataProvider {
    let cachedOrdersDataProvider: OrdersPersistentStorage

    private let network: NetworkProtocol

    func hasCachedOrders() throws -> Bool {
        try cachedOrdersDataProvider.hasCachedOrders()
    }

    /**
     Designated initialiser.
     - parameter network: `NetworkProtocol` instance to use for the networking. If no value is passed in, a default instance will be created.
     - parameter cachedOrdersDataProvider: `OrdersPersistentStorage` to use for caching the orders. The default input argument will store orders in a persistent storage.
     */
    init(network: NetworkProtocol? = nil, cachedOrdersDataProvider: OrdersPersistentStorage = CachedOrdersDataProvider.shared) {
        self.network = network ?? Network()
        self.cachedOrdersDataProvider = cachedOrdersDataProvider
    }

    func fetchOrders() async throws {
        // Only fetch orders if we don't already have them cached
        guard try !cachedOrdersDataProvider.hasCachedOrders() else { return }

        let url = try CopperEndpoint.orders.url
        let rootResponse = try await network.decodableRequest(for: url, responseModelType: OrdersResponseModel.self)
        try await cachedOrdersDataProvider.cacheOrders(rootResponse.orders)
    }
}
