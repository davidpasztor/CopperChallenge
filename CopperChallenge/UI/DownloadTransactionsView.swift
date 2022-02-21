//
//  DownloadTransactionsView.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

struct DownloadTransactionsView: View {
    private let downloadAction: () -> Void

    init(downloadAction: @escaping () -> Void) {
        self.downloadAction = downloadAction
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
        Button(action: downloadAction) {
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
    private static let viewModel = OrdersListViewModel(dataProvider: RemoteOrdersDataProvider(cachedOrdersDataProvider: CachedOrdersDataProvider.preview))

    static var previews: some View {
        Group {
            DownloadTransactionsView(downloadAction: { Task { await viewModel.fetchOrders() }})
                .preferredColorScheme(.dark)

            DownloadTransactionsView(downloadAction: { Task { await viewModel.fetchOrders() }})
                .preferredColorScheme(.light)
        }
    }
}
