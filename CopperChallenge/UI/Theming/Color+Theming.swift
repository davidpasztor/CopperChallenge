//
//  Color+Theming.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

extension ThemeManager.Color {
    /// Creates a `SwiftUI.Color` from the `ThemeManager.Color`
    var swiftUI: SwiftUI.Color {
        SwiftUI.Color(rawValue)
    }
}

