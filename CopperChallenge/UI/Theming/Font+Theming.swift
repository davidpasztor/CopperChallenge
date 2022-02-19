//
//  Font+Theming.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

import SwiftUI

extension Font {
    /// Creates a custom font using the `ThemeManager`
    static func custom(_ font: ThemeManager.Font, size: CGFloat) -> Font {
        Font.custom(font.name, size: size)
    }
}
