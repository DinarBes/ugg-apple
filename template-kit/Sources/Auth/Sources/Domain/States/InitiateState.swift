//
//  InitiateState.swift
//  template-kit
//

import Foundation

struct InitiateState: Hashable, Sendable {
    var phone: String = ""
    var isLoading: Bool = false
    var error: String? = nil
}
