//
//  OtpState.swift
//  ugg-kit
//

import Foundation

struct OtpState: Hashable, Sendable {
    var otp: String = ""
    var isLoading: Bool = false
    var error: String? = nil
}
