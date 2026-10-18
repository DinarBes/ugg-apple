//
//  AuthNavigationStack.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

public struct AuthNavigationStack: View {
    @InjectedStateObject var navigationVM: NavigationViewModel

    public init() { }

    public var body: some View {
        NavigationStack(path: $navigationVM.path) {
            InitiateScreen()
                .navigationDestination(for: OtpAuthDestination.self) { destination in
                    switch destination {
                        case let .otp(phone, sessionId):
                            OtpScreen(phone: phone, sessionId: sessionId)
                    }
                }
        }
    }
}
