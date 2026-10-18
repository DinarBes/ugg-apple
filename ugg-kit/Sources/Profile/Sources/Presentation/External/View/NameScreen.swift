//
//  NameScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// Changing the name. Saving closes the screen (KMM navigates back).
public struct NameScreen: View {
    @InjectedStateObject var viewModel: NameViewModel
    @State private var isStarted = false

    public init() { }

    public var body: some View {
        NameView(name: viewModel.name, state: viewModel.state, onSave: { viewModel.onSave() })
            .navigationTitle("Имя")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // The saved name on every visit, not on returning to this screen.
                guard !isStarted else { return }
                isStarted = true
                viewModel.load()
            }
    }
}
