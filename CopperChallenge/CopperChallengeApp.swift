//
//  CopperChallengeApp.swift
//  CopperChallenge
//
//  Created by Pásztor Dávid on 17/02/2022.
//

import SwiftUI

@main
struct CopperChallengeApp: App {
    let cachedOrdersDataProvider: CachedOrdersDataProvider
    let ordersListViewModel: OrdersListViewModel

    init() {
        let cachedOrdersDataProvider = CachedOrdersDataProvider.shared
        self.cachedOrdersDataProvider = cachedOrdersDataProvider
        let ordersDataProvider = RemoteOrdersDataProvider(cachedOrdersDataProvider: cachedOrdersDataProvider)
        self.ordersListViewModel = OrdersListViewModel(dataProvider: ordersDataProvider)
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: ordersListViewModel)
                .environment(\.managedObjectContext, cachedOrdersDataProvider.container.viewContext)
        }
    }
}
