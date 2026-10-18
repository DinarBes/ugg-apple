//
//  InitiateViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggKitCore
import UggShared

@MainActor
final class InitiateViewModel: ObservableObject {
    @Published private(set) var state = InitiateState()

    /// The digits after «+7», shown grouped («900 123-45-67»); KMM drops everything but digits.
    var nationalNumber: Binding<String> {
        Binding(
            get: { UggFormat.nationalNumber(self.state.nationalNumber) },
            set: { self.viewModel.onNationalNumberChange(digits: $0) }
        )
    }

    private let viewModel: UggShared.InitiateViewModel

    init(app: TemplateApp) {
        viewModel = app.di.initiateViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { InitiateState(from: $0) }
            .assign(to: &$state)
    }

    /// A clean phone step on every visit: the KMM view model outlives the screen.
    func reset() {
        viewModel.reset()
    }

    func onSubmit() {
        viewModel.onSubmit()
    }
}
