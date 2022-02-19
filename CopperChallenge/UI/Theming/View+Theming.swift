//
//  View+Theming.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

extension View {
    /// Sets the specified `ThemeManager.Color` as the background color of the `View`
    func backgroundColor(_ color: ThemeManager.Color) -> some View {
        background(color.swiftUI)
    }

    /// Sets the specified `ThemeManager.Color` as the foreground color of the `View`
    func foregroundColor(_ color: ThemeManager.Color) -> some View {
        foregroundColor(color.swiftUI)
    }
}

