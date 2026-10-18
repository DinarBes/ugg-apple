//
//  OtpViewModel.swift
//  ugg-kit
//

import Combine
import SwiftUI

import UggShared

@MainActor
final class OtpViewModel: ObservableObject {
    @Published private(set) var state = OtpState()

    /// The code field. KMM keeps digits only and submits by itself on the sixth one, which is why
    /// the binding needs the session.
    func otp(sessionId: String) -> Binding<String> {
        Binding(
            get: { self.state.otp },
            set: { self.viewModel.onOtpChange(otp: $0, sessionId: sessionId) }
        )
    }

    private let viewModel: UggShared.OtpViewModel

    init(app: TemplateApp) {
        viewModel = app.di.otpViewModel()

        viewModel.state.toPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in Empty() }
            .map { OtpState(from: $0) }
            .assign(to: &$state)
    }

    func reset() {
        viewModel.reset()
    }

    func onSubmit(sessionId: String) {
        viewModel.onSubmit(sessionId: sessionId)
    }

    func onResend(phone: String) {
        viewModel.resend(phone: phone)
    }
}
