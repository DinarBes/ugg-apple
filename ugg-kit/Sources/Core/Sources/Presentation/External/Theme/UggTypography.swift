//
//  UggTypography.swift
//  ugg-kit
//

import CoreText
import SwiftUI
import UIKit

/// Text styles from the Figma file — the same sizes as `UggTypography` on Android. Display styles
/// are Cormorant Garamond, the rest Manrope. Each style scales with Dynamic Type.
///
/// ```swift
/// Text("Классика").uggFont(.displayXL)
/// Text("Мастерская".uppercased()).uggFont(.overline)
/// ```
public enum UggTextStyle: CaseIterable, Sendable {
    /// 46/48 — screen heroes: «Классика».
    case displayXL
    /// 34/38 — screen titles: «Корзина», «Наши точки».
    case displayL
    /// 26/30 — section titles.
    case displayM
    /// 22/28 italic — quotes.
    case displayItalic
    /// 17/24 — card and list titles.
    case heading
    /// 15/23 — body copy.
    case body
    /// 13/19 — secondary copy.
    case bodySmall
    /// 14/20 — chips, menu rows, links.
    case label
    /// 12/16 — captions.
    case caption
    /// 11/14, tracking 14% — section kickers; uppercase the text where you render it.
    case overline
    /// 20/26 — prices.
    case price
    /// 16/20 — button labels.
    case button

    var fontName: String {
        switch self {
            case .displayXL, .displayL: "CormorantGaramond-Medium"
            case .displayM: "CormorantGaramond-SemiBold"
            case .displayItalic: "CormorantGaramond-MediumItalic"
            case .heading, .label, .overline, .button: "Manrope-SemiBold"
            case .body, .bodySmall: "Manrope-Regular"
            case .caption: "Manrope-Medium"
            case .price: "Manrope-Bold"
        }
    }

    var size: CGFloat {
        switch self {
            case .displayXL: 46
            case .displayL: 34
            case .displayM: 26
            case .displayItalic: 22
            case .heading: 17
            case .body: 15
            case .bodySmall: 13
            case .label: 14
            case .caption: 12
            case .overline: 11
            case .price: 20
            case .button: 16
        }
    }

    var lineHeight: CGFloat {
        switch self {
            case .displayXL: 48
            case .displayL: 38
            case .displayM: 30
            case .displayItalic: 28
            case .heading: 24
            case .body: 23
            case .bodySmall: 19
            case .label: 20
            case .caption: 16
            case .overline: 14
            case .price: 26
            case .button: 20
        }
    }

    /// Letter spacing in points (Figma gives it in % of the size).
    var tracking: CGFloat {
        switch self {
            case .displayXL: -0.01 * size
            case .displayL: -0.005 * size
            case .overline: 0.14 * size
            default: 0
        }
    }

    /// The Dynamic Type style the size follows.
    var relativeTo: Font.TextStyle {
        switch self {
            case .displayXL, .displayL: .largeTitle
            case .displayM, .displayItalic: .title2
            case .heading: .headline
            case .body: .body
            case .bodySmall, .label: .subheadline
            case .caption, .overline: .caption
            case .price: .title3
            case .button: .body
        }
    }

    public var font: Font {
        .custom(fontName, size: size, relativeTo: relativeTo)
    }

    /// For UIKit appearance (navigation and tab bars).
    public var uiFont: UIFont {
        UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size)
    }
}

public extension View {
    /// Font, line height and tracking of a design text style.
    func uggFont(_ style: UggTextStyle) -> some View {
        font(style.font)
            .tracking(style.tracking)
            .lineSpacing(max(0, style.lineHeight - style.uiFont.lineHeight))
    }
}

/// Registers the brand fonts bundled in UggKitCore. Call once at launch (`AppDelegate`), before
/// the first view: a font that is not registered silently falls back to the system one.
public enum UggFonts {
    public static func register() {
        // `.process` usually flattens the folder; look in both places to be safe.
        let flat = Bundle.module.urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? []
        let nested = Bundle.module.urls(forResourcesWithExtension: "ttf", subdirectory: "Fonts") ?? []
        let urls = Set(flat + nested)

        for url in urls {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
