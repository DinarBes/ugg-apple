//
//  NavigationGraphViewModel.swift
//  ugg-kit
//
//  Created by Archibbald on 17.04.2026.
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class NavigationGraphViewModel: ObservableObject {
    /// The splash is the first destination; KMM's `SplashViewModel` decides what replaces it and
    /// navigates there — nothing is resolved here.
    @Published var root: RootDestination = .splash

    private let navigationContext: NavigationContext
    private var cancellable: Set<AnyCancellable> = []

    init(app: TemplateApp) {
        navigationContext = app.navigationContext

        app.navigationContext.events.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Combine.Empty<NavigationEvent, Never>() }
            .sink { [weak self] event in
                self?.handle(event: event)
            }
            .store(in: &cancellable)
    }

    private func handle(event: NavigationEvent) {
        switch onEnum(of: event) {
            case .onNavigate(let event):
                navigate(event: event)
            case .onBack:
                // The name step closes with a KMM `back()`; underneath it is the app.
                if root == .registration { root = .launch }
        }
    }

    /// Into the app — from the onboarding and when the sign-in is closed. Goes through KMM, as on
    /// Android, so every listener sees the same route.
    func openApp() {
        navigationContext.tryNavigate(route: SplashFlow.Launch.shared, block: { _ in })
    }

    func openSignIn() {
        navigationContext.tryNavigate(route: SplashFlow.Auth.shared, block: { _ in })
    }

    private func navigate(event: NavigationEvent.OnNavigate) {
        guard let flow = event.route as? SplashFlow else { return }

        root = RootDestination(from: flow)
    }
}
