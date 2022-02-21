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
        if viewModel.hasCachedOrders {
            ordersListView
        } else {
            DownloadTransactionsView(downloadAction: {
                Task {
                    await viewModel.fetchOrders()
                }
            })
                .withLoadingStateIndicator(viewModel.loadingState, loadingView: { loadingView }, errorView: { errorView })
        }
    }

    private var ordersListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(orders, id: \.orderId) { order in
                    OrderCellView(viewModel: OrderCellViewModel(order: order))
                }
            }
        }
        .backgroundColor(.primaryBackground)
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

struct RootView_Previews: PreviewProvider {
    private static let ordersDataProvider = CachedOrdersDataProvider.preview
    @StateObject private static var viewModel = OrdersListViewModel(dataProvider: RemoteOrdersDataProvider(cachedOrdersDataProvider: ordersDataProvider))

    static var previews: some View {
        Group {
            RootView(viewModel: viewModel)
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext,
                              ordersDataProvider.container.viewContext)

            RootView(viewModel: viewModel)
                .preferredColorScheme(.light)
                .environment(\.managedObjectContext,
                              ordersDataProvider.container.viewContext)
        }
    }
}
