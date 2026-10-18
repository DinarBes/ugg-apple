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
