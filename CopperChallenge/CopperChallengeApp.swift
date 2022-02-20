//
//  CopperChallengeApp.swift
//  CopperChallenge
//
//  Created by Pásztor Dávid on 17/02/2022.
//

import SwiftUI

@main
struct CopperChallengeApp: App {
    @StateObject private var ordersListViewModel = OrdersListViewModel(dataProvider: RemoteOrdersDataProvider())

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: ordersListViewModel)
            // TODO: access this via the VM or at least via the data provider, not via the singleton
                .environment(\.managedObjectContext, CachedOrdersDataProvider.shared.container.viewContext)
        }
    }
}
