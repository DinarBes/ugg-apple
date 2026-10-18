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
import UggKitOnboarding

public struct NavigationGraphScreen: View {
    @InjectedStateObject var navigationGraphVM: NavigationGraphViewModel

    // Held by the host, not by the splash branch: it decides the first destination and keeps
    // listening for authorization events long after the splash is off screen.
    @InjectedStateObject var splashVM: SplashViewModel

    public init() { }

    public var body: some View {
        rootView
            .sheet(item: $navigationGraphVM.sheet) { sheet in
                switch sheet {
                    case .auth:
                        AuthNavigationStack(onClose: { navigationGraphVM.openApp() })
                    case .registration:
                        RegistrationScreen().interactiveDismissDisabled()
                }
            }
    }

    @ViewBuilder
    private var rootView: some View {
        switch navigationGraphVM.root {
            case .splash:
                SplashScreen(error: splashVM.error, onRetry: splashVM.onRetry)
            case .onboarding:
                OnboardingScreen(
                    onStart: { navigationGraphVM.openApp() },
                    onLogin: { navigationGraphVM.openSignIn() }
                )
            case .auth:
                AuthNavigationStack(onClose: { navigationGraphVM.openApp() })
            case .launch:
                AppTabView()
            case .registration:
                RegistrationScreen()
        }
    }
}

@available(iOS 17.0, *)
#Preview(traits: .sizeThatFitsLayout) {
    NavigationGraphScreen()
}
