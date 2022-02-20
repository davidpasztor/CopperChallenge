//
//  View+Loading.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

public extension View {
    /**
     Depending on the value of `loadingState`, either displays a loading view or an error view above the view on which the method is called.
     In case `loadingState` is `.initial` or `.loaded`, the view itself is returned unmodified.
     - parameters:
     - loadingState: varible representing the loading state - this is used to determine which view to display
     - loadingView: view to be displayed while the state is loading
     - errorView: view to be displayed in case the state is `error`
     */
    @ViewBuilder
    func withLoadingStateIndicator<LoadingView: View, ErrorView: View>(_ loadingState: LoadingState, loadingView: () -> LoadingView, errorView: () -> ErrorView) -> some View {
        switch loadingState {
        case .loading:
            // Display the loading view over the over view the method was called on
            self
                .overlay(loadingView())
        case .error:
            // In case an error was encountered, display only the error view and hide the view the method was called on
            errorView()
        case .initial, .loaded:
            // A view might not immediately start loading, so in case of initial case, we shouldn't display the loading view
            self
        }
    }
}

