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
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        return formatter
    }()

    private static let baseCurrency = "ETH"

    init(model: OrderResponseModel) {
        // TODO: if amount is > 1000, divide by 1000 and add K to the formatted amount
        self.amount = Self.formattedAmount(model: model)
        self.currency = Self.formattedCurrency(model: model)
        self.orderId = model.orderId
        self.status = model.status.rawValue.capitalized
        self.transactionDate = Self.dateFormatter.string(from: model.createdAt)
    }

    init(order: Order) {
        self.amount = order.amount.description
        self.currency = order.currency
        self.orderId = order.orderId
        self.status = order.status
        self.transactionDate = Self.dateFormatter.string(from: order.createdAt)
    }

    static func formattedAmount(model: OrderResponseModel) -> String {
        let prefix: String
        switch model.type {
        case .sell, .withdraw:
            prefix = "-"
        case .buy, .deposit:
            prefix = "+"
        }

        return "\(prefix)\(model.amount) \(model.currency)"
    }

    static func formattedCurrency(model: OrderResponseModel) -> String {
        switch model.type {
        case .deposit:
            return "In \(model.currency)"
        case .withdraw:
            return "Out \(model.currency)"
        case .buy, .sell:
            return "\(model.currency) → \(Self.baseCurrency)"
        }
    }
}

extension OrderCellViewModel: Identifiable {
    public var id: String {
        orderId
    }
}
