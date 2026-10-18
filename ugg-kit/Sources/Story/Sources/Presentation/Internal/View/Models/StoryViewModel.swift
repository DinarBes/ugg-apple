//
//  StoryViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class StoryViewModel: ObservableObject {
    @Published private(set) var state = StoryState()

    private let viewModel: UggShared.StoryViewModel

    init(app: TemplateApp) {
        // Fetches in its init.
        viewModel = app.di.storyViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { StoryState(from: $0) }
            .assign(to: &$state)
    }

    func onRetry() {
        viewModel.fetch()
    }
}
