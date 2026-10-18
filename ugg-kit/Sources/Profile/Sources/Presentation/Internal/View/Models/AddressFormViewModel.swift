//
//  AddressFormViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class AddressFormViewModel: ObservableObject {
    @Published private(set) var state = AddressFormState()

    var city: Binding<String> {
        Binding(get: { self.state.city }, set: { self.viewModel.onCityChange(city: $0) })
    }

    var street: Binding<String> {
        Binding(get: { self.state.street }, set: { self.viewModel.onStreetChange(street: $0) })
    }

    var flat: Binding<String> {
        Binding(get: { self.state.flat }, set: { self.viewModel.onFlatChange(flat: $0) })
    }

    var comment: Binding<String> {
        Binding(get: { self.state.comment }, set: { self.viewModel.onCommentChange(comment: $0) })
    }

    var isDefault: Binding<Bool> {
        Binding(get: { self.state.isDefault }, set: { self.viewModel.onDefaultChange(isDefault: $0) })
    }

    private let viewModel: UggShared.AddressFormViewModel

    init(app: TemplateApp) {
        viewModel = app.di.addressFormViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { AddressFormState(from: $0) }
            .assign(to: &$state)
    }

    /// Starts the form over: the saved address, or an empty form for `nil`.
    func load(addressId: String?) {
        viewModel.load(addressId: addressId)
    }

    /// Saves (or shows what is missing); KMM then navigates back, which closes the screen.
    func onSave() {
        viewModel.onSave()
    }

    func onDelete() {
        viewModel.onDelete()
    }
}
