//
//  OrderCellViewModel.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation

public final class OrderCellViewModel {
    /// Formatted transaction amount
    public let amount: String
    public let currency: String
    public let orderId: String
    public let status: String
    /// Formatted transaction date
    public let transactionDate: String

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // need to hardcode the locale since we're using a hardcoded date format
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        return formatter
    }()

    private static let baseCurrency = "ETH"

    init(order: Order) {
        if let orderType = OrderType(rawValue: order.type) {
            self.amount = Self.formattedAmount(order.amount.decimalValue, currency: order.currency, type: orderType)
            self.currency = Self.formatted(currency: order.currency, orderType: orderType)
        } else {
            // TODO: figure out a way to store the enum type in CoreData and hence avoid this fallback
            self.amount = ""
            self.currency = ""
        }
        self.orderId = order.orderId
        self.status = order.status.capitalized
        self.transactionDate = Self.dateFormatter.string(from: order.createdAt)
    }

    // TODO: if amount is > 1000, divide by 1000 and add K to the formatted amount
    static func formattedAmount(_ amount: Decimal, currency: String, type: OrderType) -> String {
        let prefix: String
        switch type {
        case .sell, .withdraw:
            prefix = "-"
        case .buy, .deposit:
            prefix = "+"
        }

        return "\(prefix)\(amount) \(currency)"
    }

    static func formatted(currency: String, orderType: OrderType) -> String {
        switch orderType {
        case .deposit:
            return "In \(currency)"
        case .withdraw:
            return "Out \(currency)"
        case .buy, .sell:
            return "\(currency) → \(Self.baseCurrency)"
        }
    }
}

extension OrderCellViewModel: Identifiable {
    public var id: String {
        orderId
    }
}
