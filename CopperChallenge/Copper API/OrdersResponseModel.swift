//
//  OrdersResponseModel.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation

struct OrdersResponseModel: Codable {
    let orders: [OrderResponseModel]
}
