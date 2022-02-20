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

    private let dataProvider: OrdersDataProviderProtocol

    init(dataProvider: OrdersDataProviderProtocol) {
        self.dataProvider = dataProvider
    }

    public func fetchOrders() async {
        loadingState = .loading

        do {
            try await dataProvider.fetchOrders()
        } catch {
            loadingState = .error(error)
            print(error)
        }
    }
}
