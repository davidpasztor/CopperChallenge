//
//  OrdersListView.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

struct OrdersListView: View {
    @ObservedObject private var viewModel: OrdersListViewModel

    init(viewModel: OrdersListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        LazyVStack {
            ForEach(viewModel.orderViewModels) { cellViewModel in
                OrderCellView(viewModel: cellViewModel)
            }
        }
    }
}
