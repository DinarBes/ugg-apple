//
//  UggSpacing.swift
//  ugg-kit
//

import SwiftUI

/// Spacing scale of the design — `UggTheme.spacing` on Android.
public enum UggSpacing {
    public static let xxs: CGFloat = 4
    public static let xs: CGFloat = 8
    public static let s: CGFloat = 12
    public static let m: CGFloat = 16
    public static let l: CGFloat = 20
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 28
    /// Horizontal padding of every screen.
    public static let screenHorizontal: CGFloat = 16
    /// Vertical gap between screen sections.
    public static let section: CGFloat = 28
    /// Height of primary buttons.
    public static let buttonHeight: CGFloat = 56
}

/// Corner radii of the design — `UggTheme.shapes` on Android. Use with `.continuous` corners,
/// the iOS way: `RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous)`.
public enum UggRadius {
    /// 14 — size cells, thumbnails, segmented items.
    public static let small: CGFloat = 14
    /// 20 — feature cards, delivery options, text fields.
    public static let medium: CGFloat = 20
    /// 24 — content cards, map, banners.
    public static let large: CGFloat = 24
    /// 28 — hero photo, order status card.
    public static let extraLarge: CGFloat = 28
}

