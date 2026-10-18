//
//  InitiateScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

public struct InitiateScreen: View {
    @InjectedStateObject var viewModel: InitiateViewModel

    /// A fresh form once per visit — not when coming back from the code step.
    @State private var isStarted = false

    private let onClose: () -> Void

    /// `onClose` — the close button and «Продолжить без входа»: sign-in is optional, guests land
    /// in the app.
    public init(onClose: @escaping () -> Void) {
        self.onClose = onClose
    }

    public var body: some View {
        InitiateView(
            nationalNumber: viewModel.nationalNumber,
            isComplete: viewModel.state.isComplete,
            isLoading: viewModel.state.isLoading,
            error: viewModel.state.error,
            onSubmit: { viewModel.onSubmit() },
            onSkip: onClose
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                }
                .accessibilityLabel("Закрыть")
            }
        }
        .onAppear {
            guard !isStarted else { return }
            isStarted = true
            viewModel.reset()
        }
    }
}
