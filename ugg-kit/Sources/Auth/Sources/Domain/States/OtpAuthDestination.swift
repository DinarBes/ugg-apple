//
//  OtpAuthDestination.swift
//  ugg-kit
//

import Foundation

enum OtpAuthDestination: Hashable, Sendable {
    case otp(phone: String, sessionId: String)
}
