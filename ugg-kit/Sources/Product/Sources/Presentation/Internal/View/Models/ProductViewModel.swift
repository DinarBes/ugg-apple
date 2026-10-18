//
//  ProductViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class ProductViewModel: ObservableObject {
    @Published private(set) var state = ProductState()

    private let viewModel: UggShared.ProductViewModel

    init(app: TemplateApp) {
        viewModel = app.di.productViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { ProductState(from: $0) }
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

    func onSelectShade(_ id: String) {
        viewModel.selectShade(id: id)
    }

    func onSelectHeight(_ id: String) {
        viewModel.selectHeight(id: id)
    }

    /// KMM ignores a size that is not available.
    func onSelectSize(_ label: String) {
        viewModel.selectSize(label: label)
    }

    func onToggleDetail(_ index: Int) {
        viewModel.toggleDetail(index: Int32(index))
    }

    /// Puts the selection into the cart, then `next` (the host opens the cart).
    func onAddToCart(next: @escaping () -> Void) {
        viewModel.addToCart(next: next)
    }
}
