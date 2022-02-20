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
