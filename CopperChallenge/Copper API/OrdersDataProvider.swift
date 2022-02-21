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

protocol OrdersDataProviderProtocol {
    func fetchOrders() async throws

    func hasCachedOrders() throws -> Bool
}

final class RemoteOrdersDataProvider: OrdersDataProviderProtocol {
    private let network: NetworkProtocol
    private let cachedOrdersDataProvider: OrdersPersistentStorage

    func hasCachedOrders() throws -> Bool {
        try cachedOrdersDataProvider.hasCachedOrders()
    }

    /**
     Designated initialiser.
     - parameter network: `NetworkProtocol` instance to use for the networking. If no value is passed in, a default instance will be created.
     */
    init(network: NetworkProtocol? = nil, cachedOrdersDataProvider: OrdersPersistentStorage = CachedOrdersDataProvider.shared) {
        self.network = network ?? Network()
        self.cachedOrdersDataProvider = cachedOrdersDataProvider
    }

    func fetchOrders() async throws {
        guard try !cachedOrdersDataProvider.hasCachedOrders() else { return }

        let url = try CopperEndpoint.orders.url
        let rootResponse = try await network.decodableRequest(for: url, responseModelType: OrdersResponseModel.self)
        try await cachedOrdersDataProvider.cacheOrders(rootResponse.orders)
    }
}
