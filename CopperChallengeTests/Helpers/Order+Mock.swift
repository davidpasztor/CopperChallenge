//
//  Order+Mock.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 21/02/2022.
//

import Foundation
@testable import CopperChallenge

extension Order {
    /// Test helper method that creates an `Order` with mock data
    static func createMock(amount: NSDecimalNumber = NSDecimalNumber(value: Double.random(in: 0...100)),
                           createdAt: Date = Date(),
                           currency: String = "BTC",
                           orderId: String = UUID().uuidString,
                           status: OrderStatus = .approved,
                           type: OrderType = .deposit) -> Order {
        let order = Order(context: CachedOrdersDataProvider.preview.container.viewContext)
        order.amount = amount
        order.createdAt = createdAt
        order.currency = currency
        order.orderId = orderId
        order.status = status.rawValue
        order.type = type.rawValue
        return order
    }
}
