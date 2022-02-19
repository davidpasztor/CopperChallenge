//
//  ThemeManager.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

struct ThemeManager {
    enum Color: String {
        case brandBackground
        case brandButtonForeground
        case textPrimary
        case textSecondary
    }
}

// MARK: - Fonts
extension ThemeManager {
    enum Font {
        case ibmPlexSans(IBMPlexSans)

        enum IBMPlexSans: String {
            case bold = "IBMPlexSans-Bold"
            case boldItalic = "IBMPlexSans-BoldItalic"
            case extraLight = "IBMPlexSans-ExtraLight"
            case extraLightItalic = "IBMPlexSans-ExtraLightItalic"
            case italic = "IBMPlexSans-Italic"
            case light = "IBMPlexSans-Light"
            case lightItalic = "IBMPlexSans-LightItalic"
            case medium = "IBMPlexSans-Medium"
            case mediumItalic = "IBMPlexSans-MediumItalic"
            case regular = "IBMPlexSans-Regular"
            case semiBold = "IBMPlexSans-SemiBold"
            case semiBoldItalic = "IBMPlexSans-SemiBoldItalic"
            case thin = "IBMPlexSans-Thin"
            case thinItalic = "IBMPlexSans-ThinItalic"
        }

        var name: String {
            switch self {
            case let .ibmPlexSans(font):
                return font.rawValue
            }
        }
    }
}
