//
//  RootView.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var viewModel: OrdersListViewModel

    init(viewModel: OrdersListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if viewModel.hasCachedOrders {
            OrdersListView(viewModel: viewModel)
        } else {
            DownloadTransactionsView(viewModel: viewModel)
        }
    }
}
