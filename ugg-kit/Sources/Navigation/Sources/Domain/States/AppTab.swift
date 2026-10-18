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
    case settings
    case name
    case size
    case addresses

    /// Screens KMM closes with `back()` once saved; other pushed screens close with the system back.
    var closesThroughKmm: Bool {
        switch self {
            case .name, .size: true
            default: false
        }
    }
}
