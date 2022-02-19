//
//  OrderCellView.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

struct OrderCellView: View {
    private let viewModel: OrderCellViewModel

    init(viewModel: OrderCellViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text(viewModel.currency)
                Spacer()
                Text(viewModel.amount)
            }
            HStack(spacing: 0) {
                Text(viewModel.transactionDate)
                Spacer()
                Text(viewModel.status)
            }
        }
    }
}
