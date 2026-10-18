//
//  InitiateViewModel.swift
//  template-kit
//

import Combine
import SwiftUI

import TemplateShared

@MainActor
final class InitiateViewModel: ObservableObject {
    @Published private(set) var state = InitiateState()

    /// The one field the screen edits.
    var phone: Binding<String> {
        Binding(
            get: { self.state.phone },
            set: { [self] phone in
                // The KMM view model has no per-field intent yet, so the whole state goes back and
                // the untouched fields are read off the live Kotlin state — see `clean-data-layer`.
                let dto = viewModel.state.value

                viewModel.onStateChange(new: dto.doCopy(phone: phone, isLoading: dto.isLoading, error: dto.error))
            }
        )
    }

    private let viewModel: TemplateShared.InitiateViewModel

    init(app: TemplateApp) {
        viewModel = app.di.initiateViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { InitiateState(from: $0) }
            .assign(to: &$state)
    }

    func onSubmit() {
        viewModel.onSubmit()
    }
}
