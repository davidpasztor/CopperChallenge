//
//  OrdersListViewModel.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import Foundation
import Combine

@MainActor
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

    public func fetchOrders() async {
        loadingState = .loading

        do {
            try await dataProvider.fetchOrders()
            hasCachedOrders = true
        } catch {
            loadingState = .error(error)
            print(error)
        }
    }
}
