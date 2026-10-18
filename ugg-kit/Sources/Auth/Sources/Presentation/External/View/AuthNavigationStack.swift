//
//  AuthNavigationStack.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// The sign-in flow: the phone step, the code step pushed over it with the system back gesture.
public struct AuthNavigationStack: View {
    @InjectedStateObject var navigationVM: NavigationViewModel

    private let onClose: () -> Void

    public init(onClose: @escaping () -> Void) {
        self.onClose = onClose
    }

    public var body: some View {
        NavigationStack(path: $navigationVM.path) {
            InitiateScreen(onClose: onClose)
                .navigationDestination(for: OtpAuthDestination.self) { destination in
                    switch destination {
                        case let .otp(phone, sessionId):
                            OtpScreen(phone: phone, sessionId: sessionId)
                    }
                }
        }
    }
}
