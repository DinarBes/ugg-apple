//
//  ProfileViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var state = ProfileState()

    private let viewModel: UggShared.ProfileViewModel

    init(app: TemplateApp) {
        viewModel = app.di.profileViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { ProfileState(from: $0) }
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

    func onSignOut() {
        viewModel.signOut()
    }
}
