//
//  AppTabViewModel.swift
//  template-kit
//

import Combine
import Foundation

import TemplateShared

@MainActor
final class AppTabViewModel: ObservableObject {
    @Published var tab: AppTab = .home

    private let navigationContext: TemplateShared.NavigationContext
    private var cancellable: Set<AnyCancellable> = []

    init(app: TemplateApp) {
        self.navigationContext = app.navigationContext

        navigationContext.events.toPublisher()
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
        // Handle tab switching from KMM navigation events
        // Example: case _ as HomeDestination.Home: tab = .home
    }
}
