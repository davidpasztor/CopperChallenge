//
//  OrdersListView.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI
import CoreData

struct OrdersListView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)])
    private var orders: FetchedResults<Order>

    var body: some View {
        LazyVStack {
            ForEach(orders, id: \.orderId) { order in
                OrderCellView(viewModel: OrderCellViewModel(order: order))
            }
        }
    }
}
