//
//  OnboardingViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var state = OnboardingState()

    /// The pager page; a swipe and «Далее» both go through KMM.
    var page: Binding<Int> {
        Binding(
            get: { self.state.page },
            set: { self.viewModel.setPage(page: Int32($0)) }
        )
    }

    private let viewModel: UggShared.OnboardingViewModel

    init(app: TemplateApp) {
        viewModel = app.di.onboardingViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { OnboardingState(from: $0) }
            .assign(to: &$state)
    }

    func onRetry() {
        viewModel.fetch()
    }

    /// KMM remembers that the onboarding is done, then calls `next` — so a kill in between does
    /// not show it again.
    func finish(next: @escaping () -> Void) {
        viewModel.finish(next: next)
    }
}
