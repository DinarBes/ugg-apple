//
//  AddressFormScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// A new address (`addressId == nil`) or a saved one. Saving and deleting close the screen
/// (KMM navigates back).
public struct AddressFormScreen: View {
    @InjectedStateObject var viewModel: AddressFormViewModel
    @State private var isStarted = false
    @State private var isConfirmingDelete = false

    private let addressId: String?

    public init(addressId: String?) {
        self.addressId = addressId
    }

    public var body: some View {
        AddressFormView(
            city: viewModel.city,
            street: viewModel.street,
            flat: viewModel.flat,
            comment: viewModel.comment,
            isDefault: viewModel.isDefault,
            state: viewModel.state,
            onSave: { viewModel.onSave() },
            onDelete: { isConfirmingDelete = true }
        )
        // From the route, not the state: the title does not change once the address loads.
        .navigationTitle(addressId == nil ? "Новый адрес" : "Адрес")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Удалить этот адрес?", isPresented: $isConfirmingDelete, titleVisibility: .visible) {
            Button("Удалить", role: .destructive) { viewModel.onDelete() }
            Button("Отмена", role: .cancel) { }
        }
        .onAppear {
            guard !isStarted else { return }
            isStarted = true
            viewModel.load(addressId: addressId)
        }
    }
}
