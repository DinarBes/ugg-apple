//
//  HomeViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var state = HomeState()

    private let viewModel: UggShared.HomeViewModel

    init(app: TemplateApp) {
        viewModel = app.di.homeViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { HomeState(from: $0) }
            .assign(to: &$state)
    }

    func onRetry() {
        viewModel.fetch()
    }

    /// For `.refreshable`: starts the KMM refresh and returns once it is over, so the system
    /// spinner stays exactly as long as the request.
    func onRefresh() async {
        viewModel.refresh()

        for await state in $state.values.dropFirst() where !state.isRefreshing {
            break
        }
    }
}
