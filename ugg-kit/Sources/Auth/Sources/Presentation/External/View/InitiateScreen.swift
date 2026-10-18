//
//  InitiateScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

public struct InitiateScreen: View {
    @InjectedStateObject var viewModel: InitiateViewModel

    public init() { }

    public var body: some View {
        InitiateView(
            phone: viewModel.phone,
            error: viewModel.state.error
        ) {
            Button {
                viewModel.onSubmit()
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.state.isLoading)
        }
    }
}
