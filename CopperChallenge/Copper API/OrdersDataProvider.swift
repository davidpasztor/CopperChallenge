//
//  OrdersDataProvider.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Combine
import Foundation

protocol OrdersDataProviderProtocol {
    /// `Publisher` emitting a list of orders
    func ordersPublisher() -> AnyPublisher<[OrderResponseModel], OrdersError>
}

final class OrdersDataProvider: OrdersDataProviderProtocol {
    private let network: NetworkProtocol

    /**
     Designated initialiser.
     - parameter network: `NetworkProtocol` instance to use for the networking. If no value is passed in, a default instance will be created.
     */
    init(network: NetworkProtocol? = nil) {
        self.network = network ?? Network()
    }

    func ordersPublisher() -> AnyPublisher<[OrderResponseModel], OrdersError> {
        let url: URL
        do {
            url = try CopperEndpoint.orders.url
        } catch let ordersError as OrdersError {
            return Fail(error: ordersError).eraseToAnyPublisher()
        } catch {
            return Fail(error: .generic(error)).eraseToAnyPublisher()
        }

        return network
            .decodableRequestPublisher(for: url, responseModelType: OrdersResponseModel.self)
            .map(\.orders)
            .mapError { networkingError in .networking(networkingError) }
            .eraseToAnyPublisher()
    }
}
