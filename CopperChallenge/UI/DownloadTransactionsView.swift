//
//  DownloadTransactionsView.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

struct DownloadTransactionsView: View {
    // TODO: No need to inject a whole VM (unless I move the texts to the VM as well), enough to inject the button action
    @ObservedObject private var viewModel: OrdersListViewModel

    init(viewModel: OrdersListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            logo
                .padding(.bottom, 28)
            Text("Transactions")
                .font(.custom(.ibmPlexSans(.semiBold), size: 24))
                .foregroundColor(.textPrimary)
                .padding(.bottom, 12)
            Text("Click \"Download\" to view transaction history")
                .font(.custom(.ibmPlexSans(.regular), size: 16))
                .foregroundColor(.textSecondary)
                .padding(.bottom, 40)
            downloadButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundColor(.primaryBackground)
    }

    private var logo: some View {
        Image("Logo")
            .resizable()
            .frame(width: 88, height: 88)
    }

    private var downloadButton: some View {
        Button(action: {
            Task {
                await viewModel.fetchOrders()
            }
        }) {
            Text("Download")
                .kerning(0.16)
                .font(.custom(.ibmPlexSans(.semiBold), size: 16))
                .foregroundColor(.brandButtonForeground)
        }
        .frame(width: 213, height: 56)
        .backgroundColor(.brandBackground)
        .cornerRadius(4)
    }
}

struct DownloadTransactionsView_Previews: PreviewProvider {
    @StateObject private static var viewModel = OrdersListViewModel(dataProvider: RemoteOrdersDataProvider())

    static var previews: some View {
        Group {
            DownloadTransactionsView(viewModel: viewModel)
                .preferredColorScheme(.dark)

            DownloadTransactionsView(viewModel: viewModel)
                .preferredColorScheme(.light)
        }
    }
}
