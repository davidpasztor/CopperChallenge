//
//  OrderCellViewModelTests.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 21/02/2022.
//

import XCTest
@testable import CopperChallenge

final class OrderCellViewModelTests: XCTestCase {
    func testFormattedAmount() {
        let sellOrder = Order.createMock(amount: 123, currency: "BTC", type: .sell)
        let sellFormattedAmount = OrderCellViewModel(order: sellOrder).amount
        XCTAssertEqual(sellFormattedAmount, "-123 BTC")
        let withdrawOrder = Order.createMock(amount: NSDecimalNumber(string: "3.0013"), currency: "BTC", type: .withdraw)
        let withdrawFormattedAmount = OrderCellViewModel(order: withdrawOrder).amount
        XCTAssertEqual(withdrawFormattedAmount, "-3.0013 BTC")
        let buyOrder = Order.createMock(amount: NSDecimalNumber(string: "376.4026"), currency: "MOB", type: .buy)
        let buyFormattedAmount = OrderCellViewModel(order: buyOrder).amount
        XCTAssertEqual(buyFormattedAmount, "+376.4026 MOB")
        let depositOrder = Order.createMock(amount: NSDecimalNumber(string: "86.1806628"), currency: "XRP", type: .deposit)
        let depositFormattedAmount = OrderCellViewModel(order: depositOrder).amount
        XCTAssertEqual(depositFormattedAmount, "+86.1806628 XRP")
    }

    func testFormattedCurrency() {
        let depositOrder = Order.createMock(currency: "BTC", type: .deposit)
        let depositFormattedCurrency = OrderCellViewModel(order: depositOrder).currency
        XCTAssertEqual(depositFormattedCurrency, "In BTC")
        let withdrawOrder = Order.createMock(currency: "DOGE", type: .withdraw)
        let withdrawFormattedCurrency = OrderCellViewModel(order: withdrawOrder).currency
        XCTAssertEqual(withdrawFormattedCurrency, "Out DOGE")
        let buyOrder = Order.createMock(currency: "BTC", type: .buy)
        let buyFormattedCurrency = OrderCellViewModel(order: buyOrder).currency
        XCTAssertEqual(buyFormattedCurrency, "BTC → ETH")
        let sellOrder = Order.createMock(currency: "XRP", type: .sell)
        let sellFormattedCurrency = OrderCellViewModel(order: sellOrder).currency
        XCTAssertEqual(sellFormattedCurrency, "XRP → ETH")
    }

    func testFormattedTransactionDate() throws {
        // Use a hardcoded Calendar to avoid any potential issues caused by local calendar setup on the machine running the unit tests
        let calendar = Calendar(identifier: .gregorian)
        // Given some Dates
        let dates = try [
            DateComponents(calendar: calendar, year: 2021, month: 1, day: 2, hour: 12, minute: 33).date,
            DateComponents(calendar: calendar, year: 2021, month: 4, day: 21, hour: 11, minute: 50).date,
            DateComponents(calendar: calendar, year: 2020, month: 12, day: 30, hour: 18, minute: 0).date
        ].map { try XCTUnwrap($0) }
        // and orders containing these for their createdAt property
        let orders = dates.map { Order.createMock(createdAt: $0) }
        // When initialising OrderCellViewModels from them
        let viewModels = orders.map(OrderCellViewModel.init)
        let formattedTransactionDates = viewModels.map(\.transactionDate)
        // Then their transactionDate property is correctly formatted
        let expectedTransactionDates = [
            "Jan 2, 2021 12:33 pm",
            "Apr 21, 2021 11:50 am",
            "Dec 30, 2020 6:00 pm"
        ]
        XCTAssertEqual(expectedTransactionDates, formattedTransactionDates)
    }

    func testOrderId() {
        // Given some order ID strings
        let orderIds = ["131dase12g123", "id", UUID().uuidString]
        // and Orders containing these orderIds
        let orders = orderIds.map { Order.createMock(orderId: $0) }
        // When initialising OrderCellViewModels from them
        let viewModels = orders.map(OrderCellViewModel.init)
        let formattedOrderIds = viewModels.map(\.orderId)
        // Then their orderId property matches the orderId of the order exactly
        XCTAssertEqual(formattedOrderIds, orderIds)
    }

    func testStatus() {
        // Given all possible order statuses
        let orderStatuses: [OrderStatus] = [.approved, .cancelled, .executed, .processing]
        // and Orders containing these statuses
        let orders = orderStatuses.map { Order.createMock(status: $0) }
        // When initialising OrderCellViewModels from them
        let viewModels = orders.map(OrderCellViewModel.init)
        let formattedStatuses = viewModels.map(\.status)
        // Then their status property is initialised to the uppercased version of the OrderStatus
        let expectedStatuses = ["Approved", "Canceled", "Executed", "Processing"]
        XCTAssertEqual(formattedStatuses, expectedStatuses)
    }
}
