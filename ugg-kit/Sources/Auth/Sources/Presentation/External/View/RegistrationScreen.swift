//
//  RegistrationScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// Shown once, right after the first sign-in with a new number. Both buttons end in a KMM
/// `back()`, which the navigation host turns into the app.
public struct RegistrationScreen: View {
    @InjectedStateObject var viewModel: RegistrationViewModel

    public init() { }

    public var body: some View {
        RegistrationView(
            name: viewModel.name,
            isSaving: viewModel.state.isSaving,
            canSubmit: viewModel.state.canSubmit,
            error: viewModel.state.error,
            onSubmit: { viewModel.onSubmit() },
            onSkip: { viewModel.onSkip() }
        )
    }
}
