//
//  HomeScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// Home tab. Where each block leads is the host's decision — the home screen knows nothing about
/// the other tabs.
public struct HomeScreen: View {
    @InjectedStateObject var viewModel: HomeViewModel

    private let onChooseModel: () -> Void
    private let onOpenStores: () -> Void
    private let onOpenStory: () -> Void
    private let onOpenCare: () -> Void
    private let onOpenCart: () -> Void

    public init(
        onChooseModel: @escaping () -> Void,
        onOpenStores: @escaping () -> Void,
        onOpenStory: @escaping () -> Void,
        onOpenCare: @escaping () -> Void,
        onOpenCart: @escaping () -> Void
    ) {
        self.onChooseModel = onChooseModel
        self.onOpenStores = onOpenStores
        self.onOpenStory = onOpenStory
        self.onOpenCare = onOpenCare
        self.onOpenCart = onOpenCart
    }

    public var body: some View {
        HomeView(
            state: viewModel.state,
            onRetry: { viewModel.onRetry() },
            onRefresh: { await viewModel.onRefresh() },
            onChooseModel: onChooseModel,
            onOpenStores: onOpenStores,
            onOpenStory: onOpenStory,
            onOpenCare: onOpenCare,
            onOpenCart: onOpenCart
        )
        // The wordmark and the bag are the header; the bar stays for the pushed screens' back.
        .toolbar(.hidden, for: .navigationBar)
    }
}
