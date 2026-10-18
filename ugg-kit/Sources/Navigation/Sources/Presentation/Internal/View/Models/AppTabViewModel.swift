//
//  AppTabViewModel.swift
//  ugg-kit
//

import Combine
import Foundation

import UggShared

@MainActor
final class AppTabViewModel: ObservableObject {
    @Published var tab: AppTab = .home
    /// One stack per tab, so switching tabs keeps where each one was — the iOS convention.
    @Published var homePath: [AppDestination] = []
    @Published var modelPath: [AppDestination] = []
    @Published var storesPath: [AppDestination] = []
    @Published var profilePath: [AppDestination] = []

    private let navigationContext: UggShared.NavigationContext
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

    func select(_ tab: AppTab) {
        self.tab = tab
    }

    /// Back to the root of the tab on screen, then another tab — «Выбрать пару», «Мои заказы».
    func popAndSelect(_ tab: AppTab) {
        switch self.tab {
            case .home: homePath.removeAll()
            case .model: modelPath.removeAll()
            case .stores: storesPath.removeAll()
            case .profile: profilePath.removeAll()
        }
        self.tab = tab
    }

    /// The sign-in as a sheet over the tabs (see `NavigationGraphViewModel`); the cart stays.
    func signIn() {
        navigationContext.tryNavigate(route: SplashFlow.Auth.shared, block: { _ in })
    }

    /// Pushes onto the stack of the tab on screen.
    func open(_ destination: AppDestination) {
        switch tab {
            case .home: homePath.append(destination)
            case .model: modelPath.append(destination)
            case .stores: storesPath.append(destination)
            case .profile: profilePath.append(destination)
        }
    }

    private func handle(event: NavigationEvent) {
        switch onEnum(of: event) {
            case .onNavigate:
                // Routes owned by the tabs (cart, story, care…) arrive here as the screens move
                // onto KMM navigation; for now the tabs push them directly.
                break
            case .onBack:
                break
        }
    }
}
