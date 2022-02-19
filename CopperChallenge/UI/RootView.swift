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
        Group {
            if viewModel.hasCachedOrders {
                OrdersListView()
                    .environment(\.managedObjectContext, CachedOrdersDataProvider.shared.container.viewContext)
            } else {
                DownloadTransactionsView(viewModel: viewModel)
            }
        }
        .withLoadingStateIndicator(viewModel.loadingState, loadingView: { loadingView }, errorView: { errorView })
    }

    @ViewBuilder
    private var errorView: some View {
        switch viewModel.loadingState {
        case let .error(error):
            Text(error.localizedDescription)
        default:
            EmptyView()
        }
    }

    private var loadingView: some View {
        LoadingView()
    }
}
