//
//  OtpScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

public struct OtpScreen: View {
    @InjectedStateObject var viewModel: OtpViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isStarted = false

    private let phone: String
    private let sessionId: String

    /// `phone` and `sessionId` are navigation arguments carried by `AuthFlow.Otp`, not shared state.
    public init(phone: String, sessionId: String) {
        self.phone = phone
        self.sessionId = sessionId
    }

    public var body: some View {
        OtpView(
            phone: phone,
            otp: viewModel.otp(sessionId: sessionId),
            isLoading: viewModel.state.isLoading,
            isResending: viewModel.state.isResending,
            resendCount: viewModel.state.resendCount,
            error: viewModel.state.error,
            onSubmit: { viewModel.onSubmit(sessionId: sessionId) },
            onResend: { viewModel.onResend(phone: phone) },
            // «Изменить» is the system back: the phone step is right below.
            onChangeNumber: { dismiss() }
        )
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard !isStarted else { return }
            isStarted = true
            viewModel.reset()
        }
    }
}
