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

    /// The one field the screen edits — see `InitiateViewModel.phone`.
    var otp: Binding<String> {
        Binding(
            get: { self.state.otp },
            set: { [self] otp in
                let dto = viewModel.state.value

                viewModel.onStateChange(
                    new: dto.doCopy(
                        otp: otp,
                        isLoading: dto.isLoading,
                        isResending: dto.isResending,
                        sessionId: dto.sessionId,
                        resendCount: dto.resendCount,
                        error: dto.error
                    )
                )
            }
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

    func onSubmit(sessionId: String) {
        viewModel.onSubmit(sessionId: sessionId)
    }
}
