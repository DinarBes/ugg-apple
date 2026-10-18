//
//  CartScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// The cart, pushed over a tab with the system back.
public struct CartScreen: View {
    @InjectedStateObject var viewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss

    private let onChooseModel: () -> Void
    private let onSignIn: () -> Void
    private let onOpenOrders: () -> Void

    /// - Parameters:
    ///   - onChooseModel: «Выбрать пару» on the empty cart.
    ///   - onSignIn: a guest pressed «Оформить заказ» — open the sign-in; the cart keeps its lines.
    ///   - onOpenOrders: «Мои заказы» after an order is placed.
    public init(
        onChooseModel: @escaping () -> Void,
        onSignIn: @escaping () -> Void,
        onOpenOrders: @escaping () -> Void
    ) {
        self.onChooseModel = onChooseModel
        self.onSignIn = onSignIn
        self.onOpenOrders = onOpenOrders
    }

    public var body: some View {
        CartView(
            cart: viewModel.state.cart,
            isGiftWrapped: viewModel.isGiftWrapped,
            isCheckingOut: viewModel.state.isCheckingOut,
            error: viewModel.state.error,
            onChooseModel: onChooseModel,
            onChangeQuantity: { viewModel.onChangeQuantity(lineId: $0, delta: $1) },
            onAddExtra: { viewModel.onAddExtra($0) },
            onSelectDelivery: { viewModel.onSelectDelivery($0) },
            onCheckout: { viewModel.onCheckout() }
        )
        .navigationTitle("Корзина")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: viewModel.state.isSignInRequired) { isRequired in
            guard isRequired else { return }
            viewModel.onCheckoutHandled()
            onSignIn()
        }
        .alert(
            "Заказ № \(viewModel.state.placedOrderNumber.map(String.init) ?? "") оформлен",
            isPresented: Binding(
                get: { viewModel.state.placedOrderNumber != nil },
                set: { if !$0 { viewModel.onCheckoutHandled() } }
            )
        ) {
            Button("Мои заказы") {
                viewModel.onCheckoutHandled()
                onOpenOrders()
            }
            Button("Закрыть", role: .cancel) {
                viewModel.onCheckoutHandled()
                dismiss()
            }
        } message: {
            Text("Мастер свяжется с вами, чтобы уточнить детали. Этапы пошива — в профиле.")
        }
    }
}
