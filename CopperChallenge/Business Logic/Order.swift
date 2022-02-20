//
//  Order.swift
//  CopperChallenge
//
//  Created by David Pasztor on 20/02/2022.
//

import Foundation
import CoreData

final class Order: NSManagedObject {
    @NSManaged var amount: NSDecimalNumber
    @NSManaged var createdAt: Date
    @NSManaged var currency: String
    @NSManaged var orderId: String
    @NSManaged var status: String
    @NSManaged var type: String
}

#if DEBUG
extension Order {
    static func makePreviews(count: Int, provider: CachedOrdersDataProvider) {
        for _ in 0..<count {
            let order = Order(context: provider.container.viewContext)
            order.amount = NSDecimalNumber(value: Double.random(in: 0...100))
            order.createdAt = Date()
            order.currency = ["BTC", "DOGE", "ETH", "ALGO", "MOB", "EOS"].randomElement()!
            order.orderId = UUID().uuidString
            order.status = OrderStatus.allCases.randomElement()!.rawValue
            order.type = OrderType.allCases.randomElement()!.rawValue
        }
    }
}
#endif
