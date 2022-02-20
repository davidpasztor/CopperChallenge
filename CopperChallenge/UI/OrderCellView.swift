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
            .font(.custom(.ibmPlexSans(.regular), size: 15))
            .foregroundColor(.textPrimary)
            .padding(.bottom, 4)

            HStack(spacing: 0) {
                Text(viewModel.transactionDate)
                Spacer()
                Text(viewModel.status)
            }
            .font(.custom(.ibmPlexSans(.regular), size: 13))
            .foregroundColor(.textSecondary)
            .padding(.bottom, 11)
            Divider()
                .backgroundColor(.listSeparator)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .backgroundColor(.primaryBackground)
    }
}

struct OrderCellView_Previews: PreviewProvider {
    private static let viewModel = OrderCellViewModel(order: Order.createMock(provider: .preview))

    static var previews: some View {
        Group {
            OrderCellView(viewModel: viewModel)
                .preferredColorScheme(.dark)

            OrderCellView(viewModel: viewModel)
                .preferredColorScheme(.light)
        }
    }
}
