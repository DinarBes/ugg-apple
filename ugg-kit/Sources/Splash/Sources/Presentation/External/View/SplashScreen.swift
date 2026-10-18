//
//  SplashScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

public struct SplashScreen: View {
    private let error: String?
    private let onRetry: () -> Void

    /// Values and a closure, no DI: the view model belongs to the navigation host that outlives
    /// this screen.
    public init(error: String? = nil, onRetry: @escaping () -> Void = {}) {
        self.error = error
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: UggSpacing.xl) {
            Spacer()

            UggWordmark()

            if let error {
                VStack(spacing: UggSpacing.m) {
                    Text(error)
                        .uggFont(.body)
                        .foregroundStyle(UggColors.contentSecondary)
                        .multilineTextAlignment(.center)

                    UggButton("Повторить", variant: .secondary, showsArrow: false, action: onRetry)
                        .fixedSize()
                }
                .padding(.horizontal, UggSpacing.xl)
            } else {
                ProgressView().tint(UggColors.accent)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UggColors.background.ignoresSafeArea())
    }
}

#Preview {
    SplashScreen(error: "Нет соединения с интернетом")
}
