//
//  NavigationGraphScreen.swift
//  ugg-kit
//
//  Created by Archibbald on 17.04.2026.
//

import SwiftUI

import UggKitCore
import UggKitAuth
import UggKitSplash

public struct NavigationGraphScreen: View {
    @InjectedStateObject var navigationGraphVM: NavigationGraphViewModel

    // Held by the host, not by the splash branch: it decides the first destination and keeps
    // listening for authorization events long after the splash is off screen.
    @InjectedStateObject var splashVM: SplashViewModel

    public init() { }

    public var body: some View {
        switch navigationGraphVM.root {
            case .splash:
                SplashScreen(error: splashVM.error, onRetry: splashVM.onRetry)
            case .onboarding:
                // TODO: OnboardingScreen (next step of the iOS port).
                Text("Онбординг")
            case .auth:
                AuthNavigationStack()
            case .launch:
                AppTabView()
            case .registration:
                // TODO: RegistrationScreen (next step of the iOS port).
                Text("Регистрация")
        }
    }
}

@available(iOS 17.0, *)
#Preview(traits: .sizeThatFitsLayout) {
    NavigationGraphScreen()
}
