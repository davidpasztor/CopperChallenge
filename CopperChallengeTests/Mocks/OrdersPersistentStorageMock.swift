//
//  OrdersPersistentStorageMock.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 21/02/2022.
//

import CoreData
@testable import CopperChallenge

final class OrdersPersistentStorageMock: OrdersPersistentStorage {
    var hasCachedOrdersValue: Bool

    init(hasCachedOrders: Bool = false) {
        self.hasCachedOrdersValue = hasCachedOrders
    }

    func hasCachedOrders() throws -> Bool {
        hasCachedOrdersValue
    }

    func cacheOrders(_ orders: [OrderResponseModel]) async throws {

    }
}
