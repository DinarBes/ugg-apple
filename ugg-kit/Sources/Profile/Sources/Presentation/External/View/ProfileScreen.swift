//
//  ProfileScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// Profile tab. A guest sees an offer to sign in. «Выйти» is handled here, after a confirmation;
/// the other rows and cards are the host's decision.
public struct ProfileScreen: View {
    @InjectedStateObject var viewModel: ProfileViewModel
    @State private var isConfirmingSignOut = false

    private let onSignIn: () -> Void
    private let onOpenSettings: () -> Void
    private let onOpenSize: () -> Void
    private let onOpenOrders: () -> Void
    private let onOpenAddresses: () -> Void
    private let onOpenCare: () -> Void

    public init(
        onSignIn: @escaping () -> Void,
        onOpenSettings: @escaping () -> Void,
        onOpenSize: @escaping () -> Void,
        onOpenOrders: @escaping () -> Void,
        onOpenAddresses: @escaping () -> Void,
        onOpenCare: @escaping () -> Void
    ) {
        self.onSignIn = onSignIn
        self.onOpenSettings = onOpenSettings
        self.onOpenSize = onOpenSize
        self.onOpenOrders = onOpenOrders
        self.onOpenAddresses = onOpenAddresses
        self.onOpenCare = onOpenCare
    }

    public var body: some View {
        ProfileView(
            state: viewModel.state,
            onRetry: { viewModel.onRetry() },
            onRefresh: { await viewModel.onRefresh() },
            onSignIn: onSignIn,
            onOpenSize: onOpenSize,
            onOpenOrders: onOpenOrders,
            onMenuItem: { kind in
                switch kind {
                    case .addresses: onOpenAddresses()
                    case .care: onOpenCare()
                    // TODO: «Написать в мастерскую» once the chat with the workshop exists.
                    case .contact: break
                    case .logout: isConfirmingSignOut = true
                }
            }
        )
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: onOpenSettings) {
                    UggIcon.settings.image
                }
                .accessibilityLabel("Настройки")
            }
        }
        .confirmationDialog("Выйти из аккаунта?", isPresented: $isConfirmingSignOut, titleVisibility: .visible) {
            Button("Выйти", role: .destructive) { viewModel.onSignOut() }
            Button("Остаться", role: .cancel) { }
        } message: {
            Text("Заказы и размер сохранятся — увидите их, когда войдёте по тому же номеру.")
        }
    }
}
