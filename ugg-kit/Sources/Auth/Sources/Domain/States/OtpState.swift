//
//  OtpState.swift
//  ugg-kit
//

import Foundation

struct OtpState: Hashable, Sendable {
    var otp: String = ""
    var isLoading: Bool = false
    var isResending: Bool = false
    /// Bumped on every resend — the screen restarts its countdown.
    var resendCount: Int = 0
    var error: String? = nil
}
