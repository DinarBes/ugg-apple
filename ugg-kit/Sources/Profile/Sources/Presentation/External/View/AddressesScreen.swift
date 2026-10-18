//
//  AddressesScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// The saved delivery addresses. «Добавить адрес» and a tap on a card open the form through KMM
/// (`ProfileFlow.AddressForm`); the list is live, so a saved address shows up on return.
public struct AddressesScreen: View {
    @InjectedStateObject var viewModel: AddressesViewModel

    public init() { }

    public var body: some View {
        AddressesView(
            state: viewModel.state,
            onRetry: { viewModel.onRetry() },
            onRefresh: { await viewModel.onRefresh() },
            onOpen: { viewModel.onOpen($0) },
            onAdd: { viewModel.onAdd() }
        )
        .navigationTitle("Адреса доставки")
        .navigationBarTitleDisplayMode(.inline)
    }
}
