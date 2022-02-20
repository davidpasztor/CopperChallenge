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
    @Published public private(set) var hasCachedOrders: Bool = false

    private let dataProvider: OrdersDataProviderProtocol

    init(dataProvider: OrdersDataProviderProtocol) {
        self.dataProvider = dataProvider
        do {
            self.hasCachedOrders = try dataProvider.hasCachedOrders()
        } catch {
            self.hasCachedOrders = false
        }
    }

    public func fetchOrders() async {
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
