//
//  SplashViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

/// Resolved by the navigation host, not by `SplashScreen`: the KMM view model keeps listening for
/// authorization events long after the splash leaves the screen, and it lives exactly as long as
/// the view that holds it.
@MainActor
public final class SplashViewModel: ObservableObject {
    @Published private(set) var state = SplashState()

    /// The host's read surface — `SplashState` stays internal to the package.
    public var error: String? { state.error }

    private let viewModel: UggShared.SplashViewModel

    init(app: TemplateApp) {
        viewModel = app.di.splashViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { SplashState(from: $0) }
            .assign(to: &$state)
    }

    public func onRetry() {
        viewModel.fetch()
    }
}
