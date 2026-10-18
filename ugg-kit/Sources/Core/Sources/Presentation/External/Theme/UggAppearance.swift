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

        let navigation = UINavigationBarAppearance()
        navigation.configureWithOpaqueBackground()
        navigation.backgroundColor = background
        navigation.shadowColor = .clear
        navigation.titleTextAttributes = [
            .font: UggTextStyle.heading.uiFont,
            .foregroundColor: content,
        ]
        navigation.largeTitleTextAttributes = [
            .font: UggTextStyle.displayL.uiFont,
            .foregroundColor: content,
        ]
        UINavigationBar.appearance().standardAppearance = navigation
        UINavigationBar.appearance().scrollEdgeAppearance = navigation
        UINavigationBar.appearance().compactAppearance = navigation
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
