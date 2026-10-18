//
//  SizeScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// The saved size: size, shaft height, foot length. Saving closes the screen (KMM navigates back).
public struct SizeScreen: View {
    @InjectedStateObject var viewModel: SizeViewModel
    @State private var isStarted = false

    public init() { }

    public var body: some View {
        SizeView(
            footLength: viewModel.footLength,
            state: viewModel.state,
            onRetry: { viewModel.load() },
            onSelectSize: { viewModel.onSelectSize($0) },
            onSelectHeight: { viewModel.onSelectHeight($0) },
            onSave: { viewModel.onSave() }
        )
        .navigationTitle("Мой размер")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard !isStarted else { return }
            isStarted = true
            viewModel.load()
        }
    }
}
