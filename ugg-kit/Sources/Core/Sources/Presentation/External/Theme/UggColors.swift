//
//  UggColors.swift
//  ugg-kit
//

import SwiftUI

/// Raw brand colors from the Figma file «Байкал — угги ручной работы» — the same values as
/// `UggPalette` on Android. Screens use the roles in `UggColors`, not these.
enum UggPalette {
    /// Фон приложения.
    static let milk = Color(hex: 0xFBF8F3)
    /// Карточки, поверхности.
    static let cream = Color(hex: 0xF3ECE1)
    /// Плашки фото, разделители.
    static let sand = Color(hex: 0xE7DACA)
    /// Акцент: цвет овчины.
    static let camel = Color(hex: 0xB98A5E)
    /// Тёмный акцент, цены.
    static let tobacco = Color(hex: 0x7A4F33)
    /// Основной текст, кнопки.
    static let espresso = Color(hex: 0x2A211C)
    /// Вторичный текст.
    static let taupe = Color(hex: 0x8B7F75)
    /// «Вода Байкала»: статусы «в наличии», «открыто».
    static let baikal = Color(hex: 0x6F8C99)
    static let white = Color(hex: 0xFFFFFF)
    /// Обводки и разделители.
    static let line = Color(hex: 0xE6DDD1)
    /// Ошибки.
    static let terracotta = Color(hex: 0xB4533C)
}

/// Semantic colors of the app — the roles of `UggTheme.colors` on Android: `UggColors.background`,
/// `UggColors.accent`. Light only, like the Android app.
public enum UggColors {
    /// Screen background.
    public static let background = UggPalette.milk
    /// Cards, chips, inactive segments.
    public static let surface = UggPalette.cream
    /// Photo placeholders, highlighted hint blocks.
    public static let surfaceVariant = UggPalette.sand
    /// Raised surfaces: cards with an outline, bottom bars.
    public static let surfaceElevated = UggPalette.white
    /// Dark surfaces: primary button, order status card, care banner.
    public static let surfaceInverse = UggPalette.espresso

    /// Primary text and icons.
    public static let content = UggPalette.espresso
    /// Secondary text, inactive tab items.
    public static let contentSecondary = UggPalette.taupe
    /// Text and icons on `surfaceInverse` or on photos.
    public static let contentInverse = UggPalette.milk

    /// Brand accent: overlines, links, active indicators.
    public static let accent = UggPalette.camel
    /// Prices, icons inside feature cards.
    public static let accentStrong = UggPalette.tobacco
    /// Positive / informational statuses: «в наличии», «открыто».
    public static let info = UggPalette.baikal
    public static let error = UggPalette.terracotta

    /// Outlines and dividers.
    public static let outline = UggPalette.line
}

public extension Color {
    /// `Color(hex: 0xB98A5E)` — the form colors come in from Firestore (`"#RRGGBB"` → `Long`).
    init(hex: UInt64, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
