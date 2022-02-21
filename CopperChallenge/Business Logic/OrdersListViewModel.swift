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
    @Published public private(set) var hasCachedOrders: Bool

    private let dataProvider: OrdersDataProvider

    init(dataProvider: OrdersDataProvider) {
        self.dataProvider = dataProvider
        do {
            self.hasCachedOrders = try dataProvider.hasCachedOrders()
        } catch {
            self.hasCachedOrders = false
        }
        if self.hasCachedOrders {
            self.loadingState = .loaded
        }
    }

    /// Fetches the orders from the remote API, unless there are already cached orders, in this case, no fetching is done
    public func fetchOrders() async {
        guard !hasCachedOrders else {
            return
        }

        loadingState = .loading

        do {
            try await dataProvider.fetchOrders()
            loadingState = .loaded
            self.hasCachedOrders = try dataProvider.hasCachedOrders()
        } catch {
            loadingState = .error(error)
        }
    }
}
