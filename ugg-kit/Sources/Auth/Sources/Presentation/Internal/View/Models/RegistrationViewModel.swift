//
//  RegistrationViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published private(set) var state = RegistrationState()

    var name: Binding<String> {
        Binding(
            get: { self.state.name },
            set: { self.viewModel.onNameChange(name: $0) }
        )
    }

    private let viewModel: UggShared.RegistrationViewModel

    init(app: TemplateApp) {
        viewModel = app.di.registrationViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { RegistrationState(from: $0) }
            .assign(to: &$state)
    }

    /// Saves the name; KMM then navigates back, which closes the step.
    func onSubmit() {
        viewModel.onSubmit()
    }

    func onSkip() {
        viewModel.onSkip()
    }
}
