//
//  StoresViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class StoresViewModel: ObservableObject {
    @Published private(set) var state = StoresState()

    private let viewModel: UggShared.StoresViewModel

    init(app: TemplateApp) {
        viewModel = app.di.storesViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { StoresState(from: $0) }
            .assign(to: &$state)
    }

    func onRetry() {
        viewModel.fetch()
    }

    /// For `.refreshable`: returns once the KMM refresh is over.
    func onRefresh() async {
        viewModel.refresh()

        for await state in $state.values.dropFirst() where !state.isRefreshing {
            break
        }
    }

    /// `nil` — all cities; KMM drops a selection the filter hides.
    func onSelectCity(_ city: String?) {
        viewModel.selectCity(city: city)
    }

    func onSelectStore(_ id: String?) {
        viewModel.selectStore(id: id)
    }
}
