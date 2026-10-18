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

    private var cancellable: Set<AnyCancellable> = []

    init(app: TemplateApp) {
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
                break
        }
    }

    private func navigate(event: NavigationEvent.OnNavigate) {
        guard let flow = event.route as? SplashFlow else { return }

        root = RootDestination(from: flow)
    }
}
