//
//  OrderResponseModelTests.swift
//  CopperChallengeTests
//
//  Created by David Pasztor on 19/02/2022.
//

import XCTest
@testable import CopperChallenge

final class OrderResponseModelTests: XCTestCase {
    func testInitFromDecoder() throws {
        let jsonData = try JSONLoader.loadJSONData(fileName: "Orders")
        let decodedStopPoint = try JSONDecoder().decode(OrdersResponseModel.self, from: jsonData)
        let orders = decodedStopPoint.orders
        let expectedOrderCount = 59
        XCTAssertEqual(orders.count, expectedOrderCount, "The JSON contained \(expectedOrderCount) orders, so the parsed OrdersResponseModel should've contained the same number of orders as well, but it contained \(orders.count)")
        let firstOrder = try XCTUnwrap(orders.first)
        XCTAssertEqual(firstOrder.amount, Decimal(string: "748.279727546401"))
        XCTAssertEqual(firstOrder.currency, "BTC")
        XCTAssertEqual(firstOrder.createdAt, Date(timeIntervalSince1970: TimeInterval(1595770212105 / 1000)))
        XCTAssertEqual(firstOrder.orderId, "3a16aef1d2afe8af1ad52fd4ec374fae")
        XCTAssertEqual(firstOrder.status, .approved)
        XCTAssertEqual(firstOrder.type, .deposit)
        let lastOrder = try XCTUnwrap(orders.last)
        XCTAssertEqual(lastOrder.amount, Decimal(string: "393.04984479"))
        XCTAssertEqual(lastOrder.currency, "MOB")
        XCTAssertEqual(lastOrder.createdAt, Date(timeIntervalSince1970: TimeInterval(1605932719925 / 1000)))
        XCTAssertEqual(lastOrder.orderId, "f4b237156be55b869e2cf2ac542bc20c")
        XCTAssertEqual(lastOrder.status, .cancelled)
        XCTAssertEqual(lastOrder.type, .withdraw)
    }
}
