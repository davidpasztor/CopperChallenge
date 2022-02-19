//
//  OrdersListViewModel.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation
import Combine

public final class OrdersListViewModel: ObservableObject {
    @Published public private(set) var loadingState: LoadingState = .initial

    /// Whether orders have already been downloaded and cached or if they need to be downloaded
    @Published public private(set) var hasCachedOrders: Bool = false

    @Published public private(set) var orderViewModels: [OrderCellViewModel] = []

    private let dataProvider: OrdersDataProviderProtocol

    private var downloadOrdersSubscription: AnyCancellable?

    init(dataProvider: OrdersDataProviderProtocol) {
        self.dataProvider = dataProvider
    }

    public func downloadOrders() {
        downloadOrdersSubscription = dataProvider.ordersPublisher()
            .sink(receiveCompletion: { completion in
                DispatchQueue.main.async {
                    if case .failure(let error) = completion {
                        self.loadingState = .error(error)
                    } else if case .loading = self.loadingState { // In case the publisher finished without emitting any values, set loading state to loaded
                        self.loadingState = .loaded
                    }
                }
            }, receiveValue: { [weak self] orders in
                guard let self = self else { return }
                let orderViewModels = orders.map(OrderCellViewModel.init)
                // Only dispatch the actual UI update, do all of the processing on a background thread
                DispatchQueue.main.async {
                    self.orderViewModels = orderViewModels
                    self.hasCachedOrders = true
                    self.loadingState = .loaded
                }
            })
    }
}
