//
//  CartViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class CartViewModel: ObservableObject {
    @Published private(set) var state = CartState()

    var isGiftWrapped: Binding<Bool> {
        Binding(
            get: { self.state.cart?.isGiftWrapped ?? false },
            set: { self.viewModel.setGiftWrap(enabled: $0) }
        )
    }

    private let viewModel: UggShared.CartViewModel

    init(app: TemplateApp) {
        viewModel = app.di.cartViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { CartState(from: $0) }
            .assign(to: &$state)
    }

    /// Quantity down to zero removes the line.
    func onChangeQuantity(lineId: String, delta: Int) {
        viewModel.changeQuantity(lineId: lineId, delta: Int32(delta))
    }

    func onAddExtra(_ id: String) {
        viewModel.addExtra(id: id)
    }

    func onSelectDelivery(_ id: String) {
        viewModel.selectDelivery(id: id)
    }

    /// A guest is sent to sign in first (`isSignInRequired`); the cart keeps its lines.
    func onCheckout() {
        viewModel.checkout()
    }

    /// The screen showed «Заказ оформлен» or opened the sign-in.
    func onCheckoutHandled() {
        viewModel.onCheckoutHandled()
    }
}
