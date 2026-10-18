//
//  OnboardingScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// Where the buttons lead is the host's decision: the onboarding knows nothing about the screens
/// after it.
public struct OnboardingScreen: View {
    @InjectedStateObject var viewModel: OnboardingViewModel

    private let onStart: () -> Void
    private let onLogin: () -> Void

    /// - Parameters:
    ///   - onStart: «Начать» — into the app.
    ///   - onLogin: «Войти по номеру телефона».
    public init(onStart: @escaping () -> Void, onLogin: @escaping () -> Void) {
        self.onStart = onStart
        self.onLogin = onLogin
    }

    public var body: some View {
        OnboardingView(
            slides: viewModel.state.slides,
            page: viewModel.page,
            isLastPage: viewModel.state.isLastPage,
            error: viewModel.state.error,
            onRetry: { viewModel.onRetry() },
            onStart: { viewModel.finish(next: onStart) },
            onLogin: { viewModel.finish(next: onLogin) }
        )
    }
}
