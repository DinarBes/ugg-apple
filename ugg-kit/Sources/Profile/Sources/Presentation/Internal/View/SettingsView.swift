//
//  SettingsView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// «Настройки» as a system grouped list in the brand colors. Values and closures only.
struct SettingsView: View {
    var state: SettingsState
    var onRefresh: () async -> Void
    var onEditName: () -> Void
    var onSignOut: () -> Void
    var onDeleteAccount: () -> Void

    var body: some View {
        List {
            if let account = state.account {
                Section {
                    Button(action: onEditName) {
                        HStack {
                            Text("Имя").uggFont(.label).foregroundStyle(UggColors.content)
                            Spacer()
                            Text(account.name.isEmpty ? "Не указано" : account.name)
                                .uggFont(.body)
                                .foregroundStyle(UggColors.contentSecondary)
                            UggIcon.chevronRight.image
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(UggColors.contentSecondary.opacity(0.6))
                        }
                    }
                    HStack {
                        Text("Телефон").uggFont(.label).foregroundStyle(UggColors.content)
                        Spacer()
                        Text(account.phone).uggFont(.body).foregroundStyle(UggColors.contentSecondary)
                    }
                } header: {
                    header("Профиль")
                } footer: {
                    Text("Номер — ваш вход в приложение, сменить его нельзя").uggFont(.caption)
                }
                .listRowBackground(UggColors.surfaceElevated)

                Section {
                    Button(action: onSignOut) {
                        Label("Выйти", systemImage: UggIcon.logout.rawValue)
                            .uggFont(.label)
                            .foregroundStyle(UggColors.content)
                    }
                    Button(role: .destructive, action: onDeleteAccount) {
                        HStack {
                            Text(state.isDeleting ? "Удаляем…" : "Удалить аккаунт")
                                .uggFont(.label)
                                .foregroundStyle(UggColors.error)
                            if state.isDeleting {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                    .disabled(state.isDeleting)
                } header: {
                    header("Аккаунт")
                } footer: {
                    Text("Удаление сотрёт профиль, размер и адреса").uggFont(.caption)
                }
                .listRowBackground(UggColors.surfaceElevated)
            } else if !state.isLoading {
                Section {
                    Text("Войдите по номеру телефона, чтобы указать имя и управлять аккаунтом.")
                        .uggFont(.body)
                        .foregroundStyle(UggColors.contentSecondary)
                }
                .listRowBackground(UggColors.surfaceElevated)
            }

            if let error = state.error {
                Section {
                    Text(error).uggFont(.bodySmall).foregroundStyle(UggColors.error)
                }
                .listRowBackground(UggColors.surfaceElevated)
            }

            Section {
                EmptyView()
            } footer: {
                VStack(spacing: 2) {
                    Text("Байкал · угги ручной работы")
                    if !state.version.isEmpty { Text(state.version).opacity(0.7) }
                }
                .uggFont(.caption)
                .frame(maxWidth: .infinity)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(UggColors.background.ignoresSafeArea())
        .overlay {
            if state.isLoading && state.account == nil { ProgressView().tint(UggColors.accent) }
        }
        .refreshable { await onRefresh() }
    }

    private func header(_ title: String) -> some View {
        Text(title.uppercased()).uggFont(.overline).foregroundStyle(UggColors.accent)
    }
}
