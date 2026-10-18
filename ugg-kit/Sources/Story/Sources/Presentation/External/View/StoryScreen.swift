//
//  StoryScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// «История мастерской», from the home screen.
public struct StoryScreen: View {
    @InjectedStateObject var viewModel: StoryViewModel

    private let onChooseModel: () -> Void

    public init(onChooseModel: @escaping () -> Void) {
        self.onChooseModel = onChooseModel
    }

    public var body: some View {
        StoryView(state: viewModel.state, onRetry: { viewModel.onRetry() }, onChooseModel: onChooseModel)
            .navigationBarTitleDisplayMode(.inline)
    }
}
