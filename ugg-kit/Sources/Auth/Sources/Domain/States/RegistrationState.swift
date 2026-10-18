//
//  RegistrationState.swift
//  ugg-kit
//

import Foundation

struct RegistrationState: Hashable, Sendable {
    var name: String = ""
    var isSaving: Bool = false
    var canSubmit: Bool = false
    var error: String? = nil
}
