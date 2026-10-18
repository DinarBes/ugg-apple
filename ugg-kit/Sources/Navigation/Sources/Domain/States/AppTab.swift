//
//  AppTab.swift
//  ugg-kit
//

import Foundation

/// The tabs of the app shell — the same four as `MainTab` on Android.
enum AppTab: Identifiable, Hashable, Sendable, CaseIterable {
    var id: Self { self }

    case home
    case model
    case stores
    case profile
}

/// Screens pushed over a tab, with the system back.
enum AppDestination: Hashable, Sendable {
    case story
    case care
    case cart
}
