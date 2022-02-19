//
//  CopperChallengeApp.swift
//  CopperChallenge
//
//  Created by Pásztor Dávid on 17/02/2022.
//

import SwiftUI

@main
struct CopperChallengeApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject private var ordersListViewModel = OrdersListViewModel(dataProvider: OrdersDataProvider())

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            RootView(viewModel: ordersListViewModel)
        }
    }
}
