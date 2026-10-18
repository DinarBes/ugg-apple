//
//  SettingsViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published private(set) var state = SettingsState()

    private let viewModel: UggShared.SettingsViewModel

    init(app: TemplateApp) {
        viewModel = app.di.settingsViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { SettingsState(from: $0) }
            .assign(to: &$state)
    }

    func onRefresh() async {
        viewModel.refresh()

        for await state in $state.values.dropFirst() where !state.isRefreshing {
            break
        }
    }

    /// KMM navigates to `ProfileFlow.Name`; the tab host pushes the name screen.
    func onEditName() {
        viewModel.onEditName()
    }

    func onSignOut() {
        viewModel.onSignOut()
    }

    func onDeleteAccount() {
        viewModel.onDeleteAccount()
    }

    func onDismissError() {
        viewModel.onDismissError()
    }
}
