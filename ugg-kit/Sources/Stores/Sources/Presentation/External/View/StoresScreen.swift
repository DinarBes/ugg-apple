//
//  StoresScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// «Наши точки». «Маршрут» and «Позвонить» hand off to the system (Yandex Maps or the browser,
/// the phone) — the app has no screens for them.
public struct StoresScreen: View {
    @InjectedStateObject var viewModel: StoresViewModel
    @Environment(\.openURL) private var openURL

    public init() { }

    public var body: some View {
        StoresView(
            state: viewModel.state,
            onRetry: { viewModel.onRetry() },
            onRefresh: { await viewModel.onRefresh() },
            onSelectCity: { viewModel.onSelectCity($0) },
            onSelectStore: { viewModel.onSelectStore($0) },
            onRoute: { open($0.routeUri) },
            onCall: { open($0.phoneUri) }
        )
        .navigationTitle("Наши точки")
        .navigationBarTitleDisplayMode(.large)
    }

    /// A store without a phone or route in the database has an empty link; nothing to open then.
    private func open(_ link: String) {
        guard !link.isEmpty, let url = URL(string: link) else { return }
        openURL(url)
    }
}
