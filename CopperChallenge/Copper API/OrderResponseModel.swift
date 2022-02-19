//
//  OrderResponseModel.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation

struct OrderResponseModel: Codable {
    let amount: Decimal
    let currency: String
    let createdAt: Date
    let orderId: String
    let status: OrderStatus
    let type: OrderType

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawAmount = try container.decode(String.self, forKey: .amount)
        guard let amount = Decimal(string: rawAmount) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.amount], debugDescription: "Expected a String representing a Decimal, but the String couldn't be converted to Decimal", underlyingError: nil))
        }
        self.amount = amount
        self.currency = try container.decode(String.self, forKey: .currency)
        let rawCreatedAtTimestamp = try container.decode(String.self, forKey: .createdAt)
        guard let createdAtTimestampMs = Int(rawCreatedAtTimestamp) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.createdAt], debugDescription: "Expected a String representing a timestamp, but the String couldn't be converted to a timestamp", underlyingError: nil))
        }
        // Convert to seconds
        let createdAtTimeStamp = createdAtTimestampMs / 1000
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimeStamp))
        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.status = try container.decode(OrderStatus.self, forKey: .status)
        self.type = try container.decode(OrderType.self, forKey: .type)
    }

    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case createdAt
        case orderId
        case status = "orderStatus"
        case type = "orderType"
    }
}

enum OrderStatus: String, Codable {
    case approved
    case cancelled = "canceled"
    case executed
    case processing
}

enum OrderType: String, Codable {
    case buy
    case deposit
    case sell
    case withdraw
}
