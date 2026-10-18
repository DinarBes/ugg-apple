//
//  OtpAuthDestination.swift
//  template-kit
//

import Foundation

enum OtpAuthDestination: Hashable, Sendable {
    case otp(phone: String, sessionId: String)
}
