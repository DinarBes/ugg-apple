//
//  SplashScreen.swift
//  template-kit
//

import SwiftUI

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
        VStack(spacing: 12) {
            if let error {
                Text(error)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)

                Button("Retry", action: onRetry)
            } else {
                ProgressView()
            }
        }
        .padding()
    }
}
