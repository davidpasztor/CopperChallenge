//
//  OrdersListViewModel.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Combine

public final class OrdersListViewModel: ObservableObject {
    /// Whether orders have already been downloaded and cached or if they need to be downloaded
    @Published public private(set) var hasCachedOrders: Bool = false

    private let dataProvider: OrdersDataProviderProtocol

    private var downloadOrdersSubscription: AnyCancellable?

    init(dataProvider: OrdersDataProviderProtocol) {
        self.dataProvider = dataProvider
    }

    public func downloadOrders() {
        downloadOrdersSubscription = dataProvider.ordersPublisher()
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { orders in
                print("orders received: \(orders.first)")
            })
    }
}
