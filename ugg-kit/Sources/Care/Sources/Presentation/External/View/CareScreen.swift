//
//  CareScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// «Уход за уггами», from the home screen and the profile.
public struct CareScreen: View {
    @InjectedStateObject var viewModel: CareViewModel

    private let onContact: () -> Void

    /// - Parameter onContact: «Написать в мастерскую» on the bottom card; where it leads is the host's decision.
    public init(onContact: @escaping () -> Void = { }) {
        self.onContact = onContact
    }

    public var body: some View {
        CareView(state: viewModel.state, onRetry: { viewModel.onRetry() }, onContact: onContact)
            .navigationBarTitleDisplayMode(.inline)
    }
}
