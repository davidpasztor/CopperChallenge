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
            .progressViewStyle(CircularProgressViewStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

