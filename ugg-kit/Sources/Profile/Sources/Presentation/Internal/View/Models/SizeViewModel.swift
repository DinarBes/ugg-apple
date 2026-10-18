//
//  SizeViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class SizeViewModel: ObservableObject {
    @Published private(set) var state = SizeState()

    /// KMM keeps digits and one comma only.
    var footLength: Binding<String> {
        Binding(
            get: { self.state.footLength },
            set: { self.viewModel.onFootLengthChange(input: $0) }
        )
    }

    private let viewModel: UggShared.SizeViewModel

    init(app: TemplateApp) {
        viewModel = app.di.sizeViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { SizeState(from: $0) }
            .assign(to: &$state)
    }

    /// The sizes and the saved choice — once per visit, and by «Повторить».
    func load() {
        viewModel.load()
    }

    /// Tapping the chosen size again clears it.
    func onSelectSize(_ size: String) {
        viewModel.onSelectSize(size: size)
    }

    func onSelectHeight(_ id: String) {
        viewModel.onSelectHeight(id: id)
    }

    /// Saves; KMM then navigates back, which closes the screen.
    func onSave() {
        viewModel.onSave()
    }
}
