//
//  ProductScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// The single model with its options — the «Модель» tab.
public struct ProductScreen: View {
    @InjectedStateObject var viewModel: ProductViewModel

    private let onAddToCart: () -> Void

    /// `onAddToCart` is called once the selection is in the cart (the host opens the cart).
    public init(onAddToCart: @escaping () -> Void) {
        self.onAddToCart = onAddToCart
    }

    public var body: some View {
        ProductView(
            state: viewModel.state,
            onRetry: { viewModel.onRetry() },
            onRefresh: { await viewModel.onRefresh() },
            onSelectShade: { viewModel.onSelectShade($0) },
            onSelectHeight: { viewModel.onSelectHeight($0) },
            onSelectSize: { viewModel.onSelectSize($0) },
            onToggleDetail: { viewModel.onToggleDetail($0) },
            onAddToCart: { viewModel.onAddToCart(next: onAddToCart) }
        )
        .toolbar(.hidden, for: .navigationBar)
    }
}
