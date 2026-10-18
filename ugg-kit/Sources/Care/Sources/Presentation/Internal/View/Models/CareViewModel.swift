//
//  CareViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class CareViewModel: ObservableObject {
    @Published private(set) var state = CareState()

    private let viewModel: UggShared.CareViewModel

    init(app: TemplateApp) {
        // Fetches in its init.
        viewModel = app.di.careViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { CareState(from: $0) }
            .assign(to: &$state)
    }

    func onRetry() {
        viewModel.fetch()
    }
}
