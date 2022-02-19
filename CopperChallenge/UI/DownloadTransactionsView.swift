//
//  DownloadTransactionsView.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

struct DownloadTransactionsView: View {
    @ObservedObject private var viewModel: OrdersListViewModel

    init(viewModel: OrdersListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Transactions")
            Text("Click \"Download\" to view transaction history")
            Button("Download") {
                viewModel.downloadOrders()
            }
        }
    }
}
