//
//  SettingsScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// «Настройки»: the name, signing out, deleting the account, the app version.
public struct SettingsScreen: View {
    private enum Confirmation: Identifiable {
        case signOut, delete
        var id: Self { self }
    }

    @InjectedStateObject var viewModel: SettingsViewModel
    @State private var confirmation: Confirmation?

    public init() { }

    public var body: some View {
        SettingsView(
            state: viewModel.state,
            onRefresh: { await viewModel.onRefresh() },
            onEditName: { viewModel.onEditName() },
            onSignOut: { confirmation = .signOut },
            onDeleteAccount: { confirmation = .delete }
        )
        .navigationTitle("Настройки")
        .navigationBarTitleDisplayMode(.large)
        .confirmationDialog(
            confirmation == .delete ? "Удалить аккаунт?" : "Выйти из аккаунта?",
            isPresented: Binding(get: { confirmation != nil }, set: { if !$0 { confirmation = nil } }),
            titleVisibility: .visible,
            presenting: confirmation
        ) { confirmation in
            switch confirmation {
                case .signOut:
                    Button("Выйти", role: .destructive) { viewModel.onSignOut() }
                    Button("Остаться", role: .cancel) { }
                case .delete:
                    Button("Удалить навсегда", role: .destructive) { viewModel.onDeleteAccount() }
                    Button("Отмена", role: .cancel) { }
            }
        } message: { confirmation in
            switch confirmation {
                case .signOut:
                    Text("Заказы и размер сохранятся — увидите их, когда войдёте по тому же номеру.")
                case .delete:
                    Text("Сотрём имя, размер и адреса доставки. Заказы останутся у мастерской. По этому номеру можно будет войти снова — как новый покупатель.")
            }
        }
    }
}
