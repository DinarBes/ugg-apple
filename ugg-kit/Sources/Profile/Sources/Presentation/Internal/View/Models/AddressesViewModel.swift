//
//  AddressesViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class AddressesViewModel: ObservableObject {
    @Published private(set) var state = AddressesState()

    private let viewModel: UggShared.AddressesViewModel

    init(app: TemplateApp) {
        viewModel = app.di.addressesViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { AddressesState(from: $0) }
            .assign(to: &$state)
    }

    func onRetry() {
        viewModel.observe()
    }

    /// For `.refreshable`: returns once the KMM refresh is over.
    func onRefresh() async {
        viewModel.refresh()

        for await state in $state.values.dropFirst() where !state.isRefreshing {
            break
        }
    }

    /// KMM navigates to the form (`ProfileFlow.AddressForm`), the tab pushes it.
    func onAdd() {
        viewModel.onAdd()
    }

    func onOpen(_ id: String) {
        viewModel.onOpen(id: id)
    }
}
