//
//  RootDestination.swift
//  ugg-kit
//

import Foundation

/// The Swift half of KMM's `SplashFlow` plus the splash itself.
enum RootDestination {
    case splash
    case onboarding
    case auth
    case launch
    /// Name after the first sign-in; on Android it is pushed over `launch`.
    case registration
}

/// Sign-in and the name step opened from inside the app (the cart, the profile) come up as a sheet
/// over the tabs instead of replacing them, so the cart and the open screens survive.
enum RootSheet: String, Identifiable, Hashable, Sendable {
    var id: String { rawValue }

    case auth
    case registration
}
