//
//  OtpScreen.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

public struct OtpScreen: View {
    @InjectedStateObject var viewModel: OtpViewModel

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
            otp: viewModel.otp,
            error: viewModel.state.error
        ) {
            Button {
                viewModel.onSubmit(sessionId: sessionId)
            } label: {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.state.isLoading)
        }
    }
}
