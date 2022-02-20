//
//  LoadingView.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

struct LoadingView: View {
    private let text: String

    init(text: String = "Loading...") {
        self.text = text
    }

    var body: some View {
        ProgressView(text)
            .padding(24)
            .foregroundColor(.textPrimary)
            .backgroundColor(.loadingIndicatorBackground)
            .opacity(0.9)
            .cornerRadius(8)
            .progressViewStyle(CircularProgressViewStyle())
            .tint(ThemeManager.Color.textPrimary.swiftUI)
    }
}
