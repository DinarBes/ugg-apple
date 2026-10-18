//
//  UggAppearance.swift
//  ugg-kit
//

import SwiftUI
import UIKit

/// Brand look for the system bars, so `NavigationStack` and `TabView` stay native (swipe back,
/// large titles, the tab bar) but use our fonts and colors. Call once at launch, after
/// `UggFonts.register()`.
public enum UggAppearance {
    @MainActor
    public static func apply() {
        let content = UIColor(UggColors.content)
        let background = UIColor(UggColors.background)

        let titles: (UINavigationBarAppearance) -> Void = { appearance in
            appearance.titleTextAttributes = [
                .font: UggTextStyle.heading.uiFont,
                .foregroundColor: content,
            ]
            appearance.largeTitleTextAttributes = [
                .font: UggTextStyle.displayL.uiFont,
                .foregroundColor: content,
            ]
        }

        // At the top of a screen the bar is see-through over our background, so the large title
        // shows. An opaque scroll-edge background covers the large title on iOS 26.
        let scrollEdge = UINavigationBarAppearance()
        scrollEdge.configureWithTransparentBackground()
        titles(scrollEdge)

        // Scrolled: the system material on iOS 26 (Liquid Glass), our background before it.
        let standard = UINavigationBarAppearance()
        if #available(iOS 26.0, *) {
            standard.configureWithDefaultBackground()
        } else {
            standard.configureWithOpaqueBackground()
            standard.backgroundColor = background
            standard.shadowColor = .clear
        }
        titles(standard)

        UINavigationBar.appearance().standardAppearance = standard
        UINavigationBar.appearance().compactAppearance = standard
        UINavigationBar.appearance().scrollEdgeAppearance = scrollEdge
        UINavigationBar.appearance().tintColor = content

        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = background
        tab.shadowColor = UIColor(UggColors.outline)
        let item = UITabBarItemAppearance()
        item.normal.iconColor = UIColor(UggColors.contentSecondary)
        item.normal.titleTextAttributes = [
            .font: UggTextStyle.caption.uiFont,
            .foregroundColor: UIColor(UggColors.contentSecondary),
        ]
        item.selected.iconColor = content
        item.selected.titleTextAttributes = [
            .font: UggTextStyle.caption.uiFont,
            .foregroundColor: content,
        ]
        tab.stackedLayoutAppearance = item
        tab.inlineLayoutAppearance = item
        tab.compactInlineLayoutAppearance = item
        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab
    }
}
