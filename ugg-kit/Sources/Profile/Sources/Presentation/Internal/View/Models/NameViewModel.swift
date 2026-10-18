//
//  NameViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class NameViewModel: ObservableObject {
    @Published private(set) var state = NameState()

    var name: Binding<String> {
        Binding(
            get: { self.state.name },
            set: { self.viewModel.onNameChange(name: $0) }
        )
    }

    private let viewModel: UggShared.NameViewModel

    init(app: TemplateApp) {
        viewModel = app.di.nameViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { NameState(from: $0) }
            .assign(to: &$state)
    }

    /// The saved name into the field — once per visit.
    func load() {
        viewModel.load()
    }

    /// Saves; KMM then navigates back, which closes the screen.
    func onSave() {
        viewModel.onSave()
    }
}
