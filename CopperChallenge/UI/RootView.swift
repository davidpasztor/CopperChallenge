//
//  RootView.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI
import CoreData

struct RootView: View {
    @ObservedObject private var viewModel: OrdersListViewModel

    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)])
    private var orders: FetchedResults<Order>

    init(viewModel: OrdersListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if case .loaded = viewModel.loadingState {
            ordersListView
        } else {
            DownloadTransactionsView(viewModel: viewModel)
                .withLoadingStateIndicator(viewModel.loadingState, loadingView: { loadingView }, errorView: { errorView })
        }
    }

    private var ordersListView: some View {
        List(orders, id: \.orderId) { order in
            OrderCellView(viewModel: OrderCellViewModel(order: order))
        }
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
